import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
import 'package:pocket4d/entity/component.dart';
import 'package:pocket4d/entity/data.dart';
import 'package:pocket4d/ui/base_widget.dart';
// import 'package:quickjs_dart/quickjs_dart.dart';

import 'basic.dart';

class SingleChildScrollViewTag extends BaseWidget {
  SingleChildScrollViewTag(BaseWidget parent, String pageId, Component component)
      : super(
            parent: parent,
            pageId: pageId,
            component: component,
            data: ValueNotifier(Data(component.properties)));

  @override
  _SingleChildScrollViewTagState createState() => _SingleChildScrollViewTagState();
}

class _SingleChildScrollViewTagState extends State<SingleChildScrollViewTag> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        builder: (BuildContext context, Data data, Widget child) {
          return SingleChildScrollView(
              key: ObjectKey(widget.component),
              scrollDirection:
                  MAxis.parse(data.map["scroll-direction"], defaultValue: Axis.vertical),
              child: data.children.isNotEmpty ? data.children[0] : null);
        },
        valueListenable: widget.data);
  }
}
