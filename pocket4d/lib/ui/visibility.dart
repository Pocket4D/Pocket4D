import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
import 'package:pocket4d/entity/component.dart';
import 'package:pocket4d/entity/data.dart';
// import 'package:quickjs_dart/quickjs_dart.dart';

import 'base_widget.dart';
import 'basic.dart';

class VisibilityStateless extends BaseWidget {
  VisibilityStateless(BaseWidget parent, String pageId, Component component)
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
          return Visibility(
              key: ObjectKey(component),
              visible: MBool.parse(data.map['visible'], defaultValue: true),
              child: data.children.length > 0 ? data.children[0] : null,
              replacement: data.children.length > 1 ? data.children[1] : const SizedBox.shrink());
        },
        valueListenable: this.data);
  }
}
