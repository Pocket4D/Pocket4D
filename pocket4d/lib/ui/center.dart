import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
import 'package:pocket4d/entity/component.dart';
import 'package:pocket4d/entity/data.dart';
import 'package:pocket4d/ui/base_widget.dart';
// import 'package:quickjs_dart/quickjs_dart.dart';

import 'basic.dart';

class CenterTag extends BaseWidget {
  CenterTag(BaseWidget parent, String pageId, Component component)
      : super(
            parent: parent,
            pageId: pageId,
            component: component,
            data: ValueNotifier(Data(component.properties)));

  @override
  _CenterTagState createState() => _CenterTagState();
}

class _CenterTagState extends State<CenterTag> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        builder: (BuildContext context, Data data, Widget child) {
          return Center(
              key: ObjectKey(widget.component),
              widthFactor: MDouble.parse(data.map['width-factor']),
              heightFactor: MDouble.parse(data.map['height-factor']),
              child: data.children.isNotEmpty ? data.children[0] : null);
        },
        valueListenable: widget.data);
  }
}
