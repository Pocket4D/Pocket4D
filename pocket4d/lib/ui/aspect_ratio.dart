import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
import 'package:pocket4d/entity/component.dart';
import 'package:pocket4d/entity/data.dart';
import 'package:pocket4d/ui/base_widget.dart';
import 'package:pocket4d/ui/basic.dart';
// import 'package:quickjs_dart/quickjs_dart.dart';

class AspectRatioTag extends BaseWidget {
  AspectRatioTag(BaseWidget parent, String pageId, Component component)
      : super(
            parent: parent,
            pageId: pageId,
            component: component,
            data: ValueNotifier(Data(component.properties)));

  @override
  _AspectRatioTagState createState() => _AspectRatioTagState();
}

class _AspectRatioTagState extends State<AspectRatioTag> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        builder: (BuildContext context, Data data, Widget child) {
          return AspectRatio(
              key: ObjectKey(widget.component),
              aspectRatio: MDouble.parse(data.map['aspect-ratio'], defaultValue: 0),
              child: data.children.isNotEmpty ? data.children[0] : null);
        },
        valueListenable: widget.data);
  }
}
