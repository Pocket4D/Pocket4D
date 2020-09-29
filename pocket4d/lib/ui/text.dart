import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
import 'package:pocket4d/entity/component.dart';
import 'package:pocket4d/entity/data.dart';
import 'package:pocket4d/ui/base_widget.dart';
import 'package:pocket4d/ui/basic.dart';
import 'package:pocket4d/util/color_util.dart';
// import 'package:quickjs_dart/quickjs_dart.dart';

class TextTag extends BaseWidget {
  TextTag(BaseWidget parent, String pageId, Component component)
      : super(
            parent: parent,
            pageId: pageId,
            component: component,
            data: ValueNotifier(Data(component.properties)));

  @override
  _TextTag createState() => _TextTag();
}

class _TextTag extends State<TextTag> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        builder: (BuildContext context, Data data, Widget child) {
          return Text(data.map['innerHTML'].getValue(),
              key: ObjectKey(widget.component),
              style: TextStyle(
                  inherit: MBool.parse(data.map['inherit'], defaultValue: true),
                  fontSize: MDouble.parse(data.map['font-size'], defaultValue: 14),
                  backgroundColor: dealColor(data.map['background-color']),
                  color: dealFontColor(data.map['color'])));
        },
        valueListenable: widget.data);
  }
}
