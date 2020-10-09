import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pocket4d/p4d/event_manager.dart';
import 'package:quickjs_dart/quickjs_dart.dart';
import 'package:uuid/uuid.dart';

class P4DPageManager {
  Map<String, JSValue> pageMap = Map();
  static P4DPageManager _instance;

  /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  P4DPageManager._internal();

  factory P4DPageManager() => _getInstance();

  static P4DPageManager get instance => _getInstance();

  /// 获取单例内部方法
  static _getInstance() {
    // 只能有一个实例
    if (_instance == null) {
      _instance = P4DPageManager._internal();
    }
    return _instance;
  }

  void attachPageScriptToEngine(String pageId, String script) {
    _attachPage(pageId, script);
  }

  void _attachPage(String pageId, String script) {
    var engine = JSEngine.instance;
    engine.global.getProperty("loadPage").callJS([engine.toJSVal(pageId)]);

    // might be using eval
    var realPageObject = _getJSPage(pageId);
    realPageObject.engine = engine;
    if (null != realPageObject && realPageObject is JSValue && !realPageObject.isUndefined()) {
      realPageObject.getProperty("__native__evalInPage").callJS([engine.toJSVal(script)]);

      var rawPage = engine.evalScript("global.page");
      var page = _setProtoType(rawPage, realPageObject);
      page.engine = engine;

      // realPageObject have the content now
      var newRealPageObject = _setPages(page, realPageObject);
      newRealPageObject.engine = engine;

      newRealPageObject.addCallback(DartCallback(
          engine: engine,
          name: "__native__refresh",
          handler: (args, localEngine, thisVal) {
            logger.i("__native__refresh");
            var localPageId = page.getProperty("pageId").toDartString();
            var data = engine.fromJSVal(args[0]).toString();
            onRefresh(localPageId, data);
          }));

      /// set p4d callbacks
      var p4d = newRealPageObject.getProperty("p4d");

      /// setNavigationBarTitle
      p4d.addCallback(DartCallback(
          engine: engine,
          name: 'setNavigationBarTitle',
          handler: (args, localEngine, thisVal) {
            var localPageId = page.getProperty("pageId").toDartString();
            var data = engine.fromJSVal(args[0]);
            if (null != data && (data as Map).containsKey("title")) {
              logger.i({
                "method": "setNavigationBarTitle",
                "localPageId": localPageId,
                "data": data["title"]
              });
              EventManager.eventBus.fire(EventManager.sendMessage(
                  EventManager.TYPE_NAVIGATION_BAR_TITLE, localPageId, data["title"]));
            }
          }));

      /// setNavigationBarColor
      p4d.addCallback(DartCallback(
          engine: engine,
          name: 'setNavigationBarColor',
          handler: (args, localEngine, thisVal) {
            var localPageId = page.getProperty("pageId").toDartString();
            var data = engine.fromJSVal(args[0]);
            if (null != data && (data as Map).containsKey("backgroundColor")) {
              logger.i({
                "method": "setNavigationBarColor",
                "localPageId": localPageId,
                "data": data["backgroundColor"]
              });
              EventManager.eventBus.fire(EventManager.sendMessage(
                  EventManager.TYPE_NAVIGATION_BAR_TITLE, localPageId, data["backgroundColor"]));
            }
          }));

      /// setBackgroundColor
      p4d.addCallback(DartCallback(
          engine: engine,
          name: 'setBackgroundColor',
          handler: (args, localEngine, thisVal) {
            var localPageId = page.getProperty("pageId").toDartString();
            var data = engine.fromJSVal(args[0]);
            if (null != data && (data as Map).containsKey("backgroundColor")) {
              logger.i({
                "method": "setBackgroundColor",
                "localPageId": localPageId,
                "data": data["backgroundColor"]
              });
              EventManager.eventBus.fire(EventManager.sendMessage(
                  EventManager.TYPE_BACKGROUND_COLOR, localPageId, data["backgroundColor"]));
            }
          }));

      /// navigateTo
      p4d.addCallback(DartCallback(
          engine: engine,
          name: 'navigateTo',
          handler: (args, localEngine, thisVal) async {
            var localPageId = page.getProperty("pageId").toDartString();
            // var data = engine.fromJSVal(args[0]);
            var dataString = args[0].toJSONString();
            if (null != dataString) {
              // var jsonObject = Map();
              // (data as Map).keys.forEach((element) {
              //   jsonObject.putIfAbsent(element, () => data[element]);
              // });
              // EventManager.eventBus.fire(EventManager.sendMessage(
              //     EventManager.TYPE_NAVIGATE_TO, localPageId, jsonEncode(jsonObject)));
              EventManager.eventBus.fire(
                  EventManager.sendMessage(EventManager.TYPE_NAVIGATE_TO, localPageId, dataString));
            }
          }));

      /// request
      p4d.addCallback(DartCallback(
          engine: engine,
          name: 'request',
          handler: (args, localEngine, thisVal) async {
            var localPageId = page.getProperty("pageId").toDartString();

            Map<String, dynamic> data = engine.fromJSVal(args[0]);

            var requestId = Uuid().v4();
            data["pageId"] = localPageId;
            data["requestId"] = requestId;

            p4d.getProperty("requestData").setProperty(requestId, args[0]);

            const SUCCESS = "success";
            const FAIL = "fail";

            // reuqest next
            if (null != data) {
              logger.i({"method": "request", "localPageId": localPageId, "data": data});
              var result = Map();
              result["code"] = -1;
              result["message"] = "";
              try {
                Dio dio = Dio();
                Response response = await dio.request(
                  data["url"],
                  data: data["data"],
                  options: Options(
                    method: (data["method"] as String).toUpperCase(),
                    headers: data["header"],
                    receiveTimeout: data["timeout"] ?? 30000,
                  ),
                );

                result["code"] = response.statusCode;
                result['body'] = response.data;
                result["message"] = response.statusMessage;
                result["handshake"] = response.request.connectTimeout;
                result["protocol"] = response.request.method;

                if (response.statusMessage == "OK") {
                  onNetworkResult(localPageId, data["requestId"], SUCCESS, jsonEncode(result));
                } else {
                  onNetworkResult(localPageId, data["requestId"], FAIL, jsonEncode(result));
                }
              } catch (e) {
                result["message"] = e.toString();
                logger.e(jsonEncode(result));
                onNetworkResult(localPageId, data["requestId"], FAIL, jsonEncode(result));
              }
            }
          }));

      ///startPullDownRefresh
      p4d.addCallback(DartCallback(
          engine: engine,
          name: 'startPullDownRefresh',
          handler: (args, localEngine, thisVal) {
            var localPageId = page.getProperty("pageId").toDartString();
            logger.i("startPullDownRefresh");
            EventManager.eventBus.fire(EventManager.sendMessage(
                EventManager.TYPE_TOGGLE_PULL_DOWN_REFRESH, localPageId, true));
          }));

      ///stopPullDownRefresh
      p4d.addCallback(DartCallback(
          engine: engine,
          name: 'stopPullDownRefresh',
          handler: (args, localEngine, thisVal) {
            var localPageId = page.getProperty("pageId").toDartString();
            logger.i("stopPullDownRefresh");
            EventManager.eventBus.fire(EventManager.sendMessage(
                EventManager.TYPE_TOGGLE_PULL_DOWN_REFRESH, localPageId, false));
          }));

      ///hideLoading
      p4d.addCallback(DartCallback(
          engine: engine,
          name: 'hideLoading',
          handler: (args, localEngine, thisVal) {
            var localPageId = page.getProperty("pageId").toDartString();
            logger.i("hideLoading");
            EventManager.eventBus.fire(
                EventManager.sendMessage(EventManager.TYPE_TOGGLE_LOADING, localPageId, false));
          }));

      ///showLoading
      p4d.addCallback(DartCallback(
          engine: engine,
          name: 'showLoading',
          handler: (args, localEngine, thisVal) {
            var localPageId = page.getProperty("pageId").toDartString();
            logger.i("showLoading");
            EventManager.eventBus.fire(
                EventManager.sendMessage(EventManager.TYPE_TOGGLE_LOADING, localPageId, true));
          }));

      ///hideToast
      p4d.addCallback(DartCallback(
          engine: engine,
          name: 'hideToast',
          handler: (args, localEngine, thisVal) {
            var localPageId = page.getProperty("pageId").toDartString();
            logger.i("hideToast");
            EventManager.eventBus.fire(EventManager.sendMessage(
                EventManager.TYPE_TOGGLE_TOAST, localPageId, {"show": false}));
          }));

      ///showToast
      p4d.addCallback(DartCallback(
          engine: engine,
          name: 'showToast',
          handler: (args, localEngine, thisVal) {
            var localPageId = page.getProperty("pageId").toDartString();
            logger.i("showToast");
            EventManager.eventBus.fire(EventManager.sendMessage(EventManager.TYPE_TOGGLE_TOAST,
                localPageId, {"show": true, "message": engine.fromJSVal(args[0])["title"]}));
          }));

      ///setStorage
      ///getStorage

    }
  }

  _getJSPage(String pageId) {
    var cache = pageMap[pageId];

    if (null != cache && !cache.isUndefined()) {
      return cache;
    } else {
      pageMap.remove(pageId);
    }
    var page = _getPage(pageId);
    if (page is JSValue && !page.isUndefined()) {
      pageMap.update(pageId, (value) => page, ifAbsent: () => pageMap[pageId] = page);
      return page;
    } else {
      return null;
    }
  }

  JSValue _getPage(String pageId) {
    var engine = JSEngine.instance;
    return engine.global.getProperty("getPage").callJS([engine.toJSVal(pageId)]);
  }

  JSValue _setProtoType(JSValue from, JSValue use) {
    String jsScript =
        "var setProtoTypeTo=function(a,b){var result=Object.setPrototypeOf(a,b);return result};setProtoTypeTo";
    var setPagesFunction = JSEngine.instance.evalScript(jsScript);
    return setPagesFunction.callJS([from, use]);
  }

  JSValue _setPages(JSValue pageValue, JSValue jsPage) {
    String jsScript =
        "function setPages(a,b){var keys=Object.keys(a);keys.forEach(function(key){b[key] = a[key];Object.setPrototypeOf(b, a[key]);});return b;}setPages";
    var setPagesFunction = JSEngine.instance.evalScript(jsScript);
    return setPagesFunction.callJS([pageValue, jsPage]);
  }

  void callMethodInPage(String pageId, String method, String args) {
    try {
      print({pageId, method, args});
      var engine = JSEngine.instance;
      var page = _getJSPage(pageId);
      if (method != "" &&
          page != null &&
          !(page as JSValue).isNull() &&
          !(page as JSValue).isUndefined() &&
          !((page as JSValue).getProperty(method).isNull())) {
        var params = engine.newArray();
        if (args != "" || args != null) {
          var param = engine.global
              .getProperty("JSON")
              .getProperty("parse")
              .callJS(args == null ? null : [engine.toJSVal(args)]);

          if (param.isValid() && !param.isFunction()) {
            params.invokeObject("push", [param]);
          }
        }
        var dartArray = engine.fromJSVal(params);
        var paramsVal = (dartArray as List).map((element) => engine.toJSVal(element)).toList();
        // this.currentPageId =
        //     (page as JSValue).getProperty("pageId").toDartString();

        (page as JSValue).invokeObject(method, paramsVal);
      }
    } catch (e) {
      throw e;
    }
  }

  callback(String callbackId) {
    try {
      var engine = JSEngine.instance;
      engine.global.invokeObject("callback", [engine.toJSVal(callbackId)]);
    } catch (e) {
      throw e;
    }
  }

  void onNetworkResult(String pageId, String requestId, String success, String json) {
    try {
      var engine = JSEngine.instance;
      var realPage = _getJSPage(pageId);
      if (realPage != null) {
        (realPage as JSValue).getProperty("p4d").invokeObject("onNetworkResult",
            [engine.newString(requestId), engine.newString(success), engine.newString(json)]);
      }
    } catch (e) {
      throw e;
    }
  }

  void onRefresh(String pageId, String json) {
    // logger.i({"pageId": pageId, "json": json});
    EventManager.eventBus.fire(EventManager.sendMessage(EventManager.TYPE_REFRESH, pageId, json));
  }

  JSValue handleRepeat(
      String pageId, String componentId, String type, String key, int watch, String expression) {
    var engine = JSEngine.instance;
    var page = _getJSPage(pageId);
    var watchVal = watch == 1 ? true : false;
    if (page != null) {
      try {
        var result = (page as JSValue).invokeObject("__native__getExpValue", [
          engine.newString(componentId),
          engine.newString(type),
          engine.newString(key),
          engine.newBool(watchVal),
          engine.newString(expression)
        ]);
        return result;
      } catch (e) {
        throw e;
      }
    } else {
      throw "cannot handle handleRepeat";
    }
  }

  String handleExpression(
      String pageId, String componentId, String type, String key, int watch, String expression) {
    var engine = JSEngine.instance;
    var page = _getJSPage(pageId);
    var watchVal = watch == 1 ? true : false;
    if (page != null) {
      try {
        var result = (page as JSValue).invokeObject("__native__getExpValue", [
          engine.newString(componentId),
          engine.newString(type),
          engine.newString(key),
          engine.newBool(watchVal),
          engine.newString(expression)
        ]);
        return engine.fromJSVal(result).toString();
      } catch (e) {
        throw e;
      }
    } else {
      throw "cannot handle Expression";
    }
  }

  void onInitComplete(String pageId) {
    try {
      var page = _getJSPage(pageId);
      if (page != null) {
        (page as JSValue).invokeObject("__native__initComplete", null);
      }
    } catch (e) {
      throw e;
    }
  }

  onRemovePage(String pageId) {
    try {
      var engine = JSEngine.instance;
      // engine.global.getProperty("removePage").callJS([engine.toJSVal(pageId)]);
      logger.i("onRemovePage");
      engine.evalScript("global.removePage($pageId)");
    } catch (e) {
      throw e;
    }
  }

  onRemoveObserver(String pageId, List ids) {
    try {
      var engine = JSEngine.instance;
      var page = _getJSPage(pageId);
      var paramsVal = ids.map((element) => engine.toJSVal(element)).toList();
      if (page != null) {
        (page as JSValue).invokeObject("__native__removeObserverByIds", paramsVal);
      }
    } catch (e) {
      throw e;
    }
  }
}
