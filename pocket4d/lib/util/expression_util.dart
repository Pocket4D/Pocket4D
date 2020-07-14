import 'package:flutter/services.dart';
import 'package:pocket4d/entity/component.dart';

const String TYPE_PROPERTY = "property";
const String TYPE_DIRECTIVE = "directive";

///在双花括号中获取表达式
String getExpression(String dataSource) {
  var trim = dataSource?.trim();
  if (trim.length <= 4) return "";
  return trim.substring(2, trim.length - 2);
}

///获取在for里面的表达式 判断是否有表达式前缀，有则需要拼接
///e.g.：return list
///e.g.：var index = 0; var item = list[index]; return item
String getInRepeatExp(Component component, String exp) {
  if (null == component.inRepeatPrefixExp) {
    return 'return $exp';
  }
  return '${component.inRepeatPrefixExp} return $exp';
}

///获取在for里面的表达前缀，判断父层级是否有前缀，有则需要在拼接在前面
///e.g.：var index = 0; var item = list[index];
///e.g.; var index = 0; var item = list[index]; var idx = 0; var it = item[idx];
String getInRepeatPrefixExp(
    indexName, itemName, exp, inRepeatIndex, parentInRepeatPrefixExp) {
  var prefix =
      'var $indexName = $inRepeatIndex; var $itemName = $exp[$indexName];';
  if (null != parentInRepeatPrefixExp && parentInRepeatPrefixExp.isNotEmpty) {
    prefix = '$parentInRepeatPrefixExp $prefix';
  }
  return prefix;
}

///处理property以及innerHTML
Future<void> handleProperty(
    MethodChannel methodChannel, String pageId, Component component) async {
  for (var entry in component.properties.entries.toList()) {
    var exp = entry.value.property;
    if (entry.value.containExpression) {
      exp = getExpression(exp);
      var watch = true;
      if (component.isInRepeat) {
        exp = getInRepeatExp(component, exp);
        watch = false;
      } else {
        exp = 'return $exp';
      }
      var result = await _calcExpression(methodChannel, pageId, component.id,
          TYPE_PROPERTY, entry.key, watch, exp);
//      print("$exp = $result");
      entry.value.setValue(result);
    }
  }
}

/// pageId: 页面ID
/// componentId ：组件ID
/// type ：TYPE_PROPERTY（属性）， TYPE_DIRECTIVE（指令）
/// key ： properties对应的key，方便结果回调查找
/// expression ： 表达式
Future<dynamic> calcRepeatSize(MethodChannel methodChannel, String pageId,
    String componentId, String type, String key, String expression) async {
  return await methodChannel.invokeMethod('handleRepeat', {
    'pageId': pageId,
    'id': componentId,
    'type': type,
    'key': key,
    'watch': true,
    'expression': '$expression.length'
  });
}

/// pageId: 页面ID
/// componentId ：组件ID
/// type ：TYPE_PROPERTY（属性）， TYPE_DIRECTIVE（指令）
/// key ： properties对应的key，方便结果回调查找
/// watch： 是否监听表达式进行局部刷新
/// expression ： 表达式
Future<dynamic> _calcExpression(
    MethodChannel methodChannel,
    String pageId,
    String componentId,
    String type,
    String key,
    bool watch,
    String expression) async {
  return await methodChannel.invokeMethod('handleExpression', {
    'pageId': pageId,
    'id': componentId,
    'type': type,
    'key': key,
    'watch': watch,
    'expression': expression
  });
}

/// 组件移除监听
/// ids 组件id集合
Future<void> removeObserver(
    MethodChannel methodChannel, String pageId, List<String> ids) async {
  await methodChannel
      .invokeMethod('removeObserver', {'pageId': pageId, 'ids': ids});
}
