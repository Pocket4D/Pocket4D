// import 'package:flutter/services.dart';
import 'package:pocket4d/entity/component.dart';
import 'package:pocket4d/entity/property.dart';
import 'package:pocket4d/ui/circular_progress_indicator.dart';
import 'package:pocket4d/ui/list_view.dart';
import 'package:pocket4d/ui/positioned.dart';
import 'package:pocket4d/ui/raised_button.dart';
import 'package:pocket4d/ui/row.dart';
import 'package:pocket4d/ui/single_child_scrollview.dart';
import 'package:pocket4d/ui/stack.dart';
import 'package:pocket4d/ui/text.dart';
import 'package:pocket4d/ui/visibility.dart';
import 'package:pocket4d/util/expression_util.dart';
import 'package:quickjs_dart/quickjs_dart.dart';

import 'aspect_ratio.dart';
import 'base_widget.dart';
import 'center.dart';
import 'column.dart';
import 'container.dart';
import 'expanded.dart';
import 'fractionally_sized_box.dart';
import 'image.dart';

class UIFactory {
  final String _pageId;
  // final JSEngine _engine;
  final Map<String, Component> _componentMap = Map();
  final Map<String, BaseWidget> _widgetMap = Map();

  UIFactory(this._pageId);

  /// 克隆节点id, inRepeatIndex, inRepeatPrefixExp不为空
  Component createComponentTree(
      Component parent, Map<String, dynamic> node, Map<String, dynamic> styles,
      {id, inRepeatIndex, inRepeatPrefixExp}) {
    var component = Component(parent, node, styles,
        id: id, inRepeatIndex: inRepeatIndex, inRepeatPrefixExp: inRepeatPrefixExp);
    _componentMap.putIfAbsent(component.id, () => component);
    _addChildren(component, node, styles);
    return component;
  }

  /// 为Component添加children
  _addChildren(Component parent, Map<String, dynamic> data, Map<String, dynamic> styles) {
    var children = data['childNodes'];
    if (null != children) {
      for (var child in children) {
        var result = createComponentTree(parent, child, styles);
        parent.children.add(result);
      }
    }
  }

  List<BaseWidget> _getChildren(BaseWidget parent, Component component) {
    List<BaseWidget> children = [];
    for (var it in component?.children) {
      var child = createWidgetTree(parent, it);
      if (null != child) {
        if (child is List<BaseWidget>) {
          children.addAll(child);
        } else {
          children.add(child);
        }
      }
    }
    return children;
  }

  _updateChildren(BaseWidget widget) {
    for (var it in widget.data.value.children) {
      handleProperty(_pageId, it.component);
      it.updateProperties(it.component.properties);
      if (it.data.value.children.isNotEmpty) {
        _updateChildren(it);
      }
    }
  }

  createWidgetTree(BaseWidget parent, Component component, {newSize}) {
    var repeat = component.getRealForExpression();
    if (null != repeat) {
      repeat = getInRepeatExp(component, repeat);
      var id = component.id;
      var rawSize = newSize ?? calcRepeatSize(_pageId, id, TYPE_DIRECTIVE, 'repeat', repeat);
      int size = int.parse(rawSize.toString(), radix: 10);
      if (size > 0) {
        var indexName = component.getForIndexName();
        var itemName = component.getForItemName();
        var exp = component.getRealForExpression();
        var parentInRepeatPrefixExp = component.parent?.inRepeatPrefixExp;
        List<BaseWidget> widgets = [];
        for (var index = 0; index < size; index++) {
          var inRepeatPrefixExp =
              getInRepeatPrefixExp(indexName, itemName, exp, index, parentInRepeatPrefixExp);
          var inRepeatId = "$id-$index";

          /// 缓存复用
          var clone = _componentMap[inRepeatId];
          if (null == clone) {
            clone = createComponentTree(component.parent, component.node, component.styles,
                id: inRepeatId, inRepeatIndex: index, inRepeatPrefixExp: inRepeatPrefixExp);
          }

          /// 处理表达式
          handleProperty(_pageId, clone);

          /// 缓存复用
          var widget = _widgetMap[inRepeatId];
          if (null == widget) {
            widget = _createWidget(parent, clone);
            widget.setChildren(_getChildren(widget, clone));
            _widgetMap.putIfAbsent(clone.id, () => widget);
          } else {
            /// 此处复用需要更新复用的属性及children的属性的表达式值
            widget.updateProperties(clone.properties);
            _updateChildren(widget);
          }
          widgets.add(widget);
        }
        return widgets;
      } else {
        return null;
      }
    } else {
      handleProperty(_pageId, component);
      BaseWidget widget = _createWidget(parent, component);
      widget.setChildren(_getChildren(widget, component));
      _widgetMap.putIfAbsent(component.id, () => widget);
      return widget;
    }
  }

  BaseWidget _createWidget(BaseWidget parent, Component component) {
    BaseWidget widget;
    switch (component.tag.toLowerCase()) {
      case "body":
        component.properties['width-factor'] = Property("1");
        component.properties['height-factor'] = Property("1");
        widget = CenterStateless(parent, _pageId, component);
        break;
      case "center":
        widget = CenterStateless(parent, _pageId, component);
        break;
      case "column":
        widget = ColumnStateless(parent, _pageId, component);
        break;
      case "row":
        widget = RowStateless(parent, _pageId, component);
        break;
      case "stack":
        widget = StackStateless(parent, _pageId, component);
        break;
      case "positioned":
        widget = PositionedStateless(parent, _pageId, component);
        break;
      case "singlechildscrollview":
        widget = SingleChildScrollViewStateless(parent, _pageId, component);
        break;
      case "listview":
        widget = ListViewStateless(parent, _pageId, component);
        break;
//      case "nestedscrollview":
//        widget = _createNestedScrollView(component.properties, child);
//        break;
//      case "clipoval":
//        widget = _createClipOval(component.properties, child);
//        break;
      case "container":
        widget = ContainerStateless(parent, _pageId, component);
        break;
      case "expanded":
        widget = ExpandedStateless(parent, _pageId, component);
        break;
      case "fractionallysizedbox":
        widget = FractionallySizedBoxStateless(parent, _pageId, component);
        break;
      case "aspectratio":
        widget = AspectRatioStateless(parent, _pageId, component);
        break;
      case "raisedbutton":
        widget = RaisedButtonStateless(parent, _pageId, component);
        break;
      case "visibility":
        widget = VisibilityStateless(parent, _pageId, component);
        break;
      case "text":
        widget = TextStateless(parent, _pageId, component);
        break;
      case "image":
        widget = ImageStateless(parent, _pageId, component);
        break;
      case "circularprogressindicator":
        widget = CircularProgressIndicatorStateless(parent, _pageId, component);
        break;
      default:
        var text = Property('未实现控件${component.tag}');
        var font = Property('14');
        var color = Property('red');
        component.properties = Map()
          ..putIfAbsent('font-size', () => font)
          ..putIfAbsent('color', () => color)
          ..putIfAbsent('innerHTML', () => text);
        widget = TextStateless(parent, _pageId, component);
        break;
    }
    return widget;
  }

  void clear() {
    _componentMap.clear();
    _widgetMap.clear();
  }

  List<BaseWidget> _getNewChildren(
      Component parent, Component component, BaseWidget parentWidget, int size) {
    List<BaseWidget> children = [];
    for (var it in parent.children) {
      if (it == component) {
        List<BaseWidget> result = createWidgetTree(parentWidget, component, newSize: size);
        if (null != result) {
          children.addAll(result);
        }
      } else {
        /// 如果是for节点需要把原来的children迁移过来
        if (null != it.getForExpression()) {
          parentWidget.data.value.children.forEach((child) {
            if (child.component.id.startsWith(it.id)) {
              children.add(child);
            }
          });
        } else {
          var widget = _widgetMap[it.id];
          if (null != widget) {
            children.add(widget);
          }
        }
      }
    }
    return children;
  }

  updateTree(List<dynamic> list) {
    for (var it in list) {
      var type = it['type'];
      var id = it['id'];
      switch (type) {
        case TYPE_DIRECTIVE:

          /// 更新for需要将parentComponent的children重新检查更新一遍
          if (_componentMap.containsKey(id)) {
            var component = _componentMap[id];
            var parentId = component.parent.id;
            if (_componentMap.containsKey(parentId) && _widgetMap.containsKey(parentId)) {
              var parentComponent = _componentMap[parentId];
              var parentWidget = _widgetMap[parentId];
              var newSize = it['value'];
              var children = _getNewChildren(parentComponent, component, parentWidget, newSize);
              parentWidget.updateChildren(children);
            }
          }
          break;
        case TYPE_PROPERTY:
          if (_widgetMap.containsKey(id)) {
            var widget = _widgetMap[id];
            widget.updateProperty(it);
          }
          break;
      }
    }
  }
}
