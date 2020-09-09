import 'package:pocket4d/p4d/page_manager.dart';

final manager = P4DPageManager.instance;

void attachPage(String pageId, String script) {
  manager.attachPageScriptToEngine(pageId, script);
}

void initComplete(String pageId) {
  manager.onInitComplete(pageId);
}

void onLoad(String pageId, String args) {
  manager.callMethodInPage(pageId, 'onLoad', args);
}

void onUnload(String pageId) {
  manager.callMethodInPage(pageId, 'onUnload', null);
}

void onPullDownRefresh(String pageId) {
  manager.callMethodInPage(pageId, 'onPullDownRefresh', null);
}

void event(String pageId, String event, String data) {
  manager.callMethodInPage(pageId, event, data);
}

void removeObServer(String pageId, List ids) {
  manager.onRemoveObserver(pageId, ids);
}

String handleRepeat(
    String pageId, String expression, String id, String type, String key, int watch) {
  var result = manager.handleRepeat(pageId, id, type, key, watch, expression);
  return result.toDartString();
}

String handleExpression(
    String pageId, String expression, String id, String type, String key, int watch) {
  return manager.handleExpression(pageId, id, type, key, watch, expression);
}
