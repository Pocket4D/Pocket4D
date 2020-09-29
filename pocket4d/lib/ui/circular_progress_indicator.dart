import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:pocket4d/entity/component.dart';
import 'package:pocket4d/entity/data.dart';
import 'package:pocket4d/ui/basic.dart';
// import 'package:quickjs_dart/quickjs_dart.dart';

import 'base_widget.dart';

class CircularProgressIndicatorTag extends BaseWidget {
  CircularProgressIndicatorTag(BaseWidget parent, String pageId, Component component)
      : super(
            parent: parent,
            pageId: pageId,
            component: component,
            data: ValueNotifier(Data(component.properties)));

  @override
  _CircularProgressIndicatorTagState createState() => _CircularProgressIndicatorTagState();
}

class _CircularProgressIndicatorTagState extends State<CircularProgressIndicatorTag> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        builder: (BuildContext context, Data data, Widget child) {
          return CircularProgressIndicator(
            key: ObjectKey(widget.component),
            value: MDouble.parse(data.map['value']),
            backgroundColor: MColor.parse(data.map['background-color']),
//            valueColor: ,
            strokeWidth: MDouble.parse(data.map["stroke-width"], defaultValue: 4.0),
            semanticsLabel: data.map["semantics-label"]?.getValue(),
            semanticsValue: data.map["semantics-value"]?.getValue(),
          );
        },
        valueListenable: widget.data);
  }
}
