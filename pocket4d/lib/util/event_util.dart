import 'dart:convert';

// import 'package:flutter/services.dart';
import 'package:pocket4d/entity/property.dart';
import 'package:pocket4d/p4d/view_controller.dart' as viewApis;

const String TYPE_TAP = "tap";
const String TYPE_SCROLL = "scroll";
const String TYPE_INPUT = "input";

String _createTapEvent(String id, Map<String, dynamic> dataSet, String type) {
  Map<String, dynamic> target = Map();
  target.putIfAbsent('id', () => id);
  target.putIfAbsent('dataset', () => dataSet);
  Map<String, dynamic> event = Map();
  event.putIfAbsent('type', () => type);
  event.putIfAbsent('target', () => target);
  return jsonEncode(event);
}

String _createFocusEvent(String id, String type) {
  Map<String, dynamic> detail = Map();
  detail.putIfAbsent('id', () => id);
  Map<String, dynamic> event = Map();
  event.putIfAbsent('type', () => type);
  event.putIfAbsent('detail', () => detail);
  return jsonEncode(event);
}

String _createBlurEvent(String id, String type) {
  Map<String, dynamic> detail = Map();
  detail.putIfAbsent('id', () => id);
  Map<String, dynamic> event = Map();
  event.putIfAbsent('type', () => type);
  event.putIfAbsent('detail', () => detail);
  return jsonEncode(event);
}

String _createInputEvent(String id, String value, String type) {
  Map<String, dynamic> detail = Map();
  detail.putIfAbsent('id', () => id);
  detail.putIfAbsent('value', () => value);
  Map<String, dynamic> event = Map();
  event.putIfAbsent('type', () => type);
  event.putIfAbsent('detail', () => detail);
  return jsonEncode(event);
}

String _createConfirmEvent(String id, String value, String type) {
  Map<String, dynamic> detail = Map();
  detail.putIfAbsent('id', () => id);
  detail.putIfAbsent('value', () => value);
  Map<String, dynamic> event = Map();
  event.putIfAbsent('type', () => type);
  event.putIfAbsent('detail', () => detail);
  return jsonEncode(event);
}

String _createScrollEvent(String id, double offset, String type) {
  Map<String, dynamic> detail = Map();
  detail.putIfAbsent('id', () => id);
  detail.putIfAbsent('offset', () => offset);
  Map<String, dynamic> event = Map();
  event.putIfAbsent('type', () => type);
  event.putIfAbsent('detail', () => detail);
  return jsonEncode(event);
}

onTapEvent(String pageId, String id, Map<String, Property> properties, String event) {
  var prefix = 'data-';
  var dataSet = Map<String, dynamic>();
  properties.forEach((k, v) {
    if (k.startsWith(prefix)) {
      var key = k.substring(prefix.length);
      try {
        dataSet.putIfAbsent(key, jsonDecode(v.getValue()));
      } catch (e) {
        dataSet.putIfAbsent(key, () => v.getValue());
      }
    }
  });
  var func = event.replaceAll('()', '');
  String json = _createTapEvent(id, dataSet, TYPE_TAP);
  // methodChannel.invokeMethod('event', {'pageId': pageId, 'event': func, 'data': json});
  viewApis.event(pageId, func, json);
}

onInputEvent(String pageId, String id, String event, String value) {
  var func = event.replaceAll('()', '');
  String json = _createInputEvent(id, value, TYPE_INPUT);
  viewApis.event(pageId, func, json);
}

onConfirmEvent(String pageId, String id, String event, String value) {
  var func = event.replaceAll('()', '');
  String json = _createConfirmEvent(id, value, TYPE_INPUT);
  viewApis.event(pageId, func, json);
}

onFocusEvent(String pageId, String id, String event) {
  var func = event.replaceAll('()', '');
  String json = _createFocusEvent(id, TYPE_INPUT);
  viewApis.event(pageId, func, json);
}

onBlurEvent(String pageId, String id, String event) {
  var func = event.replaceAll('()', '');
  String json = _createBlurEvent(id, TYPE_INPUT);
  viewApis.event(pageId, func, json);
}

onScrollEvent(String pageId, String id, String event, double offset) {
  var func = event.replaceAll('()', '');
  String json = _createScrollEvent(id, offset, TYPE_SCROLL);
//  print('json = $json');
  // methodChannel.invokeMethod('event', {'pageId': pageId, 'event': func, 'data': json});
  viewApis.event(pageId, func, json);
}

onScrollLimitEvent(String pageId, String id, String event) {
  var func = event.replaceAll('()', '');
  // methodChannel.invokeMethod('event', {'pageId': pageId, 'event': func, 'data': ""});
  viewApis.event(pageId, func, "");
}
