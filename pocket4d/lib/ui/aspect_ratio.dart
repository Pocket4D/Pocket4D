import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pocket4d/entity/component.dart';
import 'package:pocket4d/entity/data.dart';
import 'package:pocket4d/ui/base_widget.dart';
import 'package:pocket4d/ui/basic.dart';

class AspectRatioStateless extends BaseWidget {
  AspectRatioStateless(BaseWidget parent, String pageId,
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
          return AspectRatio(
              key: ObjectKey(component),
              aspectRatio:
                  MDouble.parse(data.map['aspect-ratio'], defaultValue: 0),
              child: data.children.isNotEmpty ? data.children[0] : null);
        },
        valueListenable: this.data);
  }
}
