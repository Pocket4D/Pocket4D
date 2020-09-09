import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:pocket4d/entity/component.dart';
import 'package:pocket4d/entity/data.dart';
import 'package:pocket4d/ui/base_widget.dart';
import 'package:pocket4d/util/color_util.dart';
import 'package:pocket4d/util/event_util.dart';
// import 'package:quickjs_dart/quickjs_dart.dart';

class RaisedButtonStateless extends BaseWidget {
  RaisedButtonStateless(BaseWidget parent, String pageId, Component component)
      : super(
            parent: parent,
            pageId: pageId,
            // engine: engine,
            component: component,
            data: ValueNotifier(Data(component.properties)));

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        builder: (BuildContext context, Data data, Widget child) {
          Color color = dealColor(data.map['color']);
          Color textColor = dealColor(data.map['text-color']);
          Color disabledTextColor = dealColor(data.map['disabled-text-color']);
          Color disabledColor = dealColor(data.map['disabled-color']);
          Color focusColor = dealColor(data.map['focus-color']);
          Color hoverColor = dealColor(data.map['hover-color']);
          Color highlightColor = dealColor(data.map['highlight-color']);
          Color splashColor = dealColor(data.map['splash-color']);

          return RaisedButton(
              onPressed: () {
                var bindTap = component.events['bindtap'];
                if (null != bindTap) {
                  onTapEvent(pageId, this.hashCode.toString(), data.map, bindTap);
                }
              },
              key: ObjectKey(component),
              textColor: textColor,
              disabledTextColor: disabledTextColor,
              color: color,
              disabledColor: disabledColor,
              focusColor: focusColor,
              hoverColor: hoverColor,
              highlightColor: highlightColor,
              splashColor: splashColor,
              child: data.children.isNotEmpty ? data.children[0] : null);
        },
        valueListenable: this.data);
  }
}
