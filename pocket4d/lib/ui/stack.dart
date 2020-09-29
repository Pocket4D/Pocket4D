import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
import 'package:pocket4d/entity/component.dart';
import 'package:pocket4d/entity/data.dart';
import 'package:pocket4d/ui/base_widget.dart';
// import 'package:quickjs_dart/quickjs_dart.dart';

import 'basic.dart';

class StackTag extends BaseWidget {
  StackTag(BaseWidget parent, String pageId, Component component)
      : super(
            parent: parent,
            pageId: pageId,
            component: component,
            data: ValueNotifier(Data(component.properties)));

  @override
  _StackTagState createState() => _StackTagState();
}

class _StackTagState extends State<StackTag> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        builder: (BuildContext context, Data data, Widget child) {
          var alignment = MAlignmentDirectional.parse(data.map['alignment'],
              defaultValue: AlignmentDirectional.topStart);
          return Stack(
              key: ObjectKey(widget.component),
              alignment: alignment,
              textDirection: MTextDirection.parse(data.map['text-direction']),
              fit: MStackFit.parse(data.map['fit'], defaultValue: StackFit.loose),
              overflow: MOverflow.parse(data.map['overflow'], defaultValue: Overflow.clip),
              children: data.children);
        },
        valueListenable: widget.data);
  }
}
