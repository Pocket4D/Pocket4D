import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pocket4d/entity/component.dart';
import 'package:pocket4d/entity/data.dart';
import 'package:pocket4d/ui/base_widget.dart';
import 'package:pocket4d/ui/basic.dart';

class FractionallySizedBoxStateless extends BaseWidget {
  FractionallySizedBoxStateless(BaseWidget parent, String pageId,
      MethodChannel methodChannel, Component component)
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
          var widthFactor =
              MDouble.parse(data.map['width-factor'], defaultValue: 0);
          var heightFactor =
              MDouble.parse(data.map['height-factor'], defaultValue: 0);
          return FractionallySizedBox(
              key: ObjectKey(component),
              widthFactor: widthFactor,
              heightFactor: heightFactor,
              child: data.children.isNotEmpty ? data.children[0] : null);
        },
        valueListenable: this.data);
  }
}
