import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
import 'package:pocket4d/entity/component.dart';
import 'package:pocket4d/entity/data.dart';
import 'package:pocket4d/ui/base_widget.dart';
// import 'package:quickjs_dart/quickjs_dart.dart';

import 'basic.dart';

class PositionedStateless extends BaseWidget {
  PositionedStateless(BaseWidget parent, String pageId, Component component)
      : super(
            parent: parent,
            pageId: pageId,
            component: component,
            data: ValueNotifier(Data(component.properties)));
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        builder: (BuildContext context, Data data, Widget child) {
          return Positioned(
              key: ObjectKey(component),
              left: MDouble.parse(data.map['left']),
              right: MDouble.parse(data.map['right']),
              top: MDouble.parse(data.map['top']),
              bottom: MDouble.parse(data.map['bottom']),
              width: MDouble.parse(data.map['width']),
              height: MDouble.parse(data.map['height']),
              child: data.children.isNotEmpty ? data.children[0] : null);
        },
        valueListenable: this.data);
  }
}
