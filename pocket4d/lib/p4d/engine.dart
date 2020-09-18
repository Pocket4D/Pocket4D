import 'dart:core';
import 'package:quickjs_dart/quickjs_dart.dart';
import 'package:pocket4d/p4d/framework.dart';

import 'page_manager.dart';

class P4DEngine {
  JSEngine _jsEngine;
  String errorTag = '< PocketEngine Error >';

  JSValue get global => JSEngine.instance.global;

  bool _isAlive = false;
  bool _frameworkLoaded = false;

  bool get framworkLoaded => _frameworkLoaded;

  bool get isAlive => _isAlive;

  P4DPageManager manager;

  /// engine start
  P4DEngine.start() {
    _jsEngine = JSEngine();
    _isAlive = true;
    _init();
    initMiniApp();
  }

  /// engine stop
  P4DEngine.stop() {
    _isAlive = false;
    dispose();
  }

  P4DEngine.loop() {
    if (_isAlive == true) {
      JSEngine.loop(_jsEngine);
    }
  }

  /// provide dispose when widget disposed
  dispose() {
    _jsEngine.stop();
  }

  _init() {
    registerDartGlobal();
  }

  initMiniApp() {
    loadFrameWork();
    runPageManager();
  }

  loadFrameWork([String frameworkString = framework]) {
    try {
      var _framework = JSEngine.instance.evalScript(frameworkString);
      print(_framework.valueType);
      if (_framework.isValid()) {
        _frameworkLoaded = true;
      } else {
        _frameworkLoaded = false;
      }
    } catch (e) {
      _frameworkLoaded = false;
      throw '$errorTag :Framework is not successfully loaded';
    }
  }

  runPageManager() {
    manager = P4DPageManager();
  }

  registerDartGlobal() {
    /// __native__setTimeout
    /// __native__clearTimeout
    /// __native__setInterval
    /// __native__clearInterval
  }

  static JSValue executeScript(String script) {
    try {
      return JSEngine.instance.evalScript(script);
    } catch (e) {
      throw e;
    }
  }

  static JSValue callJS(JSValue thisVal, List<JSValue> params) {
    try {
      return JSEngine.instance.callJS(thisVal, params);
    } catch (e) {
      throw e;
    }
  }
}
