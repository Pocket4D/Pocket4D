import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
import 'package:pocket4d/entity/component.dart';
import 'package:pocket4d/entity/data.dart';
import 'package:pocket4d/ui/base_widget.dart';
// import 'package:quickjs_dart/quickjs_dart.dart';

import 'basic.dart';

class ContainerStateless extends BaseWidget {
  ContainerStateless(BaseWidget parent, String pageId, Component component)
      : super(
            parent: parent,
            pageId: pageId,
            // engine: engine,
            component: component,
            data: ValueNotifier(Data(component.properties)));

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        builder: (BuildContext context, Data data, Widget child) {
          var alignment = MAlignment.parse(data.map['alignment'], defaultValue: Alignment.topLeft);

          return Container(
              key: ObjectKey(component),
              alignment: alignment,
              color: MColor.parse(data.map['color']),
              width: MDouble.parse(data.map['width']),
              height: MDouble.parse(data.map['height']),
              margin: MMargin.parse(data.map),
              padding: MPadding.parse(data.map),
              child: data.children.isNotEmpty ? data.children[0] : null);
        },
        valueListenable: this.data);
  }
}
