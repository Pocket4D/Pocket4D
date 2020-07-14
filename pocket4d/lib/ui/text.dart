import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pocket4d/entity/component.dart';
import 'package:pocket4d/entity/data.dart';
import 'package:pocket4d/ui/base_widget.dart';
import 'package:pocket4d/ui/basic.dart';
import 'package:pocket4d/util/color_util.dart';

class TextStateless extends BaseWidget {
  TextStateless(BaseWidget parent, String pageId, MethodChannel methodChannel,
      Component component)
      : super(
            parent: parent,
            pageId: pageId,
            methodChannel: methodChannel,
            component: component,
            data: ValueNotifier(Data(component.properties)));

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        builder: (BuildContext context, Data data, Widget child) {
          return Text(data.map['innerHTML'].getValue(),
              key: ObjectKey(component),
              style: TextStyle(
                  inherit: MBool.parse(data.map['inherit'], defaultValue: true),
                  fontSize:
                      MDouble.parse(data.map['font-size'], defaultValue: 14),
                  backgroundColor: dealColor(data.map['background-color']),
                  color: dealFontColor(data.map['color'])));
        },
        valueListenable: this.data);
  }
}
