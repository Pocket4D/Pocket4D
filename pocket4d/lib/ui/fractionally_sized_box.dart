import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
import 'package:pocket4d/entity/component.dart';
import 'package:pocket4d/entity/data.dart';
import 'package:pocket4d/ui/base_widget.dart';
import 'package:pocket4d/ui/basic.dart';
// import 'package:quickjs_dart/quickjs_dart.dart';

class FractionallySizedBoxTag extends BaseWidget {
  FractionallySizedBoxTag(BaseWidget parent, String pageId, Component component)
      : super(
            parent: parent,
            pageId: pageId,
            component: component,
            data: ValueNotifier(Data(component.properties)));

  @override
  _FractionallySizedBoxTagState createState() => _FractionallySizedBoxTagState();
}

class _FractionallySizedBoxTagState extends State<FractionallySizedBoxTag> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        builder: (BuildContext context, Data data, Widget child) {
          var widthFactor = MDouble.parse(data.map['width-factor'], defaultValue: 0);
          var heightFactor = MDouble.parse(data.map['height-factor'], defaultValue: 0);
          return FractionallySizedBox(
              key: ObjectKey(widget.component),
              widthFactor: widthFactor,
              heightFactor: heightFactor,
              child: data.children.isNotEmpty ? data.children[0] : null);
        },
        valueListenable: widget.data);
  }
}
