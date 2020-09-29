import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
import 'package:pocket4d/entity/component.dart';
import 'package:pocket4d/entity/data.dart';
import 'package:pocket4d/ui/base_widget.dart';
// import 'package:quickjs_dart/quickjs_dart.dart';

import 'basic.dart';

class RowTag extends BaseWidget {
  RowTag(BaseWidget parent, String pageId, Component component)
      : super(
            parent: parent,
            pageId: pageId,
            component: component,
            data: ValueNotifier(Data(component.properties)));

  @override
  _RowTagState createState() => _RowTagState();
}

class _RowTagState extends State<RowTag> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        builder: (BuildContext context, Data data, Widget child) {
          return Row(
              key: ObjectKey(widget.component),
              mainAxisAlignment: MMainAxisAlignment.parse(data.map["main-axis-alignment"],
                  defaultValue: MainAxisAlignment.start),
              mainAxisSize:
                  MMainAxisSize.parse(data.map["main-axis-size"], defaultValue: MainAxisSize.max),
              crossAxisAlignment: MCrossAxisAlignment.parse(data.map["cross-axis-alignment"],
                  defaultValue: CrossAxisAlignment.center),
              textDirection: MTextDirection.parse(data.map["text-direction"]),
              verticalDirection: MVerticalDirection.parse(data.map["vertical-direction"],
                  defaultValue: VerticalDirection.down),
              textBaseline: MTextBaseline.parse(data.map["text-baseline"]),
              children: data.children);
        },
        valueListenable: widget.data);
  }
}
