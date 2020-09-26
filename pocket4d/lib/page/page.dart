import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pocket4d/p4d/event_manager.dart';
import 'package:pocket4d/p4d/view_controller.dart' as viewApi;
import 'package:pocket4d/ui/ui_factory.dart';
import 'package:pocket4d/util/base64.dart';
import 'package:pocket4d/util/color_util.dart';
import 'package:quickjs_dart/quickjs_dart.dart';
import 'package:thrio/thrio.dart';

import 'abstract.dart';

class P4DPage extends StatefulWidget {
  final String appId;
  final String name;
  final Map<String, dynamic> args;
  final Map<String, dynamic> pages;
  final Map<String, dynamic> handlers;
  final String indexPage;
  final String bundleApiUrl;

  P4DPage(this.bundleApiUrl, this.appId, this.name, this.args, this.pages, this.handlers,
      this.indexPage);

  @override
  _P4DPageState createState() => _P4DPageState(args, pages, handlers, indexPage);
}

class _P4DPageState extends State<P4DPage> with P4DMessageHandler {
  Map<String, dynamic> _args = Map();
  Map<String, String> _pages = Map();
  Map<String, P4DMessageHandler> _handlers = Map();
  String _indexPage = "";
  Map<String, dynamic> _data;

  Color _appBarColor;
  Color _backgroundColor;
  bool _enablePullDownRefresh;

  String _pageCode = "";
  String _pageId = "";
  String _title = "";
  Widget _tree;
  bool _loading = false;

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;

  UIFactory _factory;

  Completer<bool> _completer;

  StreamSubscription _sub;

  _P4DPageState(this._args, this._pages, this._handlers, this._indexPage) {
    if (_args.containsKey("pageCode")) {
      _pageCode = _args['pageCode'];
      _args = Map<String, dynamic>.from(_args['args']);
    } else {
      _pageCode = _indexPage;
    }
    _appBarColor = Colors.blue;
    _backgroundColor = Colors.grey[200];
    _enablePullDownRefresh = false;
    _pageId = _pageCode + this.hashCode.toString();
    _factory = UIFactory(_pageId);
    _handlers.putIfAbsent(_pageId, () => this);
  }

  _initMessageHandler(Map<String, dynamic> message) {
    logger.i(message);
    var pageId = message['pageId'];
    P4DMessageHandler handler = _handlers[pageId];
    if (null != handler) {
      handler.onMessage(message);
    } else {
      var pageCode = message['pageCode'];
      var content = message['content'];
      _pages.putIfAbsent(pageCode, () => content);
      _handlers.forEach((k, v) {
        if (pageCode != null && k.startsWith(pageCode)) {
          logger.i(message);
          v.onMessage(message);
        }
      });
    }
  }

  void _socket(Map<String, dynamic> map) {
    if (null == context) return;
    if (null != _factory) {
      _factory.clear();
      _callOnUnload();
    }
    var jsonObject = jsonDecode(map['message']);
    var pageCode = jsonObject['pageCode'];
    var content = jsonObject['content'];
    if (_pageCode == pageCode) {
      _data = jsonDecode(content);
      _factory.clear();
      _create();
    }
  }

  void _update(Map<String, dynamic> map) {
    var jsonObject = jsonDecode(map['message']);
    _factory.updateTree(jsonObject);
  }

  void _updateTitle(Map<String, dynamic> map) {
    setState(() {
      _title = map['message'];
    });
  }

  void _setNavigationBarColor(Map<String, dynamic> map) {
    setState(() {
      _appBarColor = parseColor(map['message'], defaultValue: Colors.blue);
    });
  }

  void _setBackgroundColor(Map<String, dynamic> map) {
    setState(() {
      _backgroundColor = parseColor(map['message'], defaultValue: Colors.grey[200]);
    });
  }

  void _navigateTo(Map<String, dynamic> map) {
    var jsonObject = jsonDecode(map['message']);
    var url = jsonObject['url'];
    if (null != url) {
      var uri = Uri.parse(url);
      var path = uri.path;
      var params = uri.queryParameters;
      if (null != path && path.isNotEmpty) {
        var args = Map<String, dynamic>()
          ..putIfAbsent("pageCode", () => path)
          ..putIfAbsent("args", () => params);
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => P4DPage(widget.bundleApiUrl, widget.appId, widget.name, args,
        //         _pages, _handlers, _indexPage)));
        ThrioNavigator.push(url: '/p4dApp', params: {
          "bundleApiUrl": widget.bundleApiUrl,
          "appId": widget.appId,
          "name": widget.name,
          "args": args,
        });
      }
    }
  }

  void _create() async {
    var body = _data['body'];
    var styles = _data['style'];
    var script = _data['script'];
    var config = _data['config'];
    if (null == script) {
      script = "";
    }

    _initConfig(config);
    _initScript(script);
    _callOnLoad();
    var component = await _factory.createComponentTree(null, body, styles);
    var tree = await _factory.createWidgetTree(null, component);

    setState(() {
      _tree = tree;
    });
  }

  void _initConfig(Map<String, dynamic> config) {
    if (null == config) {
      return;
    }
    _title = config['navigationBarTitleText'];
    _appBarColor = parseColor(config['navigationBarBackgroundColor'], defaultValue: Colors.blue);
    _backgroundColor = parseColor(config['backgroundColor'], defaultValue: Colors.grey[200]);
    _enablePullDownRefresh = config['enablePullDownRefresh'];
  }

  void _initScript(String script) {
    // logger.i(decodeBase64(script));
    viewApi.attachPage(_pageId, decodeBase64(script));
    viewApi.initComplete(_pageId);
  }

  void _callOnLoad() {
    viewApi.onLoad(_pageId, jsonEncode(_args));
  }

  void _callOnUnload() {
    viewApi.onUnload(_pageId);
  }

  void _togglePullDownRefresh(Map<String, dynamic> map) {
    if (map["message"] == true) {
      if (null != _refreshIndicatorKey) {
        _refreshIndicatorKey.currentState.show();
      }
    } else {
      if (null != _completer) {
        _completer.complete(true);
      }
    }
  }

  void _toggleLoading(Map<String, dynamic> map) {
    if (map["message"] != null) {
      setState(() {
        _loading = map["message"] as bool;
      });
    }
  }

  void _toggleToast(Map<String, dynamic> map) {
    if (map["message"]["show"] == true) {
      Fluttertoast.showToast(
          msg: map["message"]["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.cancel();
    }
  }

  Future<void> _onRefresh() async {
    viewApi.onPullDownRefresh(_pageId);
    _completer = new Completer<bool>();
    return _completer.future.then((bool success) {
      return success;
    });
  }

  @override
  Widget build(BuildContext context) {
    var child = _tree;
    if (_loading == false) {
      if (null != _enablePullDownRefresh && _enablePullDownRefresh && null != _tree) {
        _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
        child = RefreshIndicator(key: _refreshIndicatorKey, onRefresh: _onRefresh, child: _tree);
      }
    } else {
      child = Center(child: Text("Global Loading..."));
    }

    return Scaffold(
        key: PageStorageKey(_tree),
        appBar: AppBar(
            title: Text(_title),
            centerTitle: true,
            backgroundColor: _appBarColor,
            leading: const IconButton(
              color: Colors.white,
              tooltip: 'back',
              icon: Icon(Icons.arrow_back),
              onPressed: ThrioNavigator.pop,
            )),
        backgroundColor: _backgroundColor,
        body: child);
  }

  @override
  void initState() {
    super.initState();
    _sub = EventManager.eventBus.on<Map<String, dynamic>>().listen(_initMessageHandler);
    _data = jsonDecode(_pages[_pageCode]);
    _create();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
//    logger.i("lifecycle didChangeDependencies $_pageId");
  }

  @override
  void dispose() {
    logger.i("lifecycle dispose $_pageId");
    _handlers.remove(_pageId);
    _factory.clear();
    _callOnUnload();
    _sub.cancel();
    super.dispose();
  }

  @override
  void onMessage(Map<String, dynamic> message) {
    // TODO: implement onMessage
    int type = message['type'];
    switch (type) {
      case EventManager.TYPE_SOCKET: //socket
        _socket(message);
        break;
      case EventManager.TYPE_REFRESH: //onclick setData
        _update(message);
        break;
      case EventManager.TYPE_NAVIGATION_BAR_TITLE: //set_navigation_bar_title
        _updateTitle(message);
        break;
      case EventManager.TYPE_NAVIGATE_TO: //navigate_to
        _navigateTo(message);
        break;
      case EventManager.TYPE_NAVIGATION_BAR_COLOR: //set_navigation_bar_color
        _setNavigationBarColor(message);
        break;
      case EventManager.TYPE_BACKGROUND_COLOR: //set_background_color
        _setBackgroundColor(message);
        break;
      case EventManager.TYPE_TOGGLE_LOADING:
        _toggleLoading(message);
        break;
      case EventManager.TYPE_TOGGLE_TOAST:
        _toggleToast(message);
        break;
      case EventManager.TYPE_TOGGLE_PULL_DOWN_REFRESH:
        _togglePullDownRefresh(message);
        break;
    }
  }
}
