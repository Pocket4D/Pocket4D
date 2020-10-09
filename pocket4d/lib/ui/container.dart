import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
import 'package:pocket4d/entity/component.dart';
import 'package:pocket4d/entity/data.dart';
import 'package:pocket4d/ui/base_widget.dart';
import 'package:pocket4d/util/event_util.dart';
// import 'package:quickjs_dart/quickjs_dart.dart';

import 'basic.dart';

class ContainerTag extends BaseWidget {
  ContainerTag(BaseWidget parent, String pageId, Component component)
      : super(
            parent: parent,
            pageId: pageId,
            component: component,
            data: ValueNotifier(Data(component.properties)));

  @override
  _ContainerTagState createState() => _ContainerTagState();
}

class _ContainerTagState extends State<ContainerTag> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        builder: (BuildContext context, Data data, Widget child) {
          var alignment = MAlignment.parse(data.map['alignment'], defaultValue: Alignment.topLeft);
          var direction = MAxis.parse(data.map["flex-direction"], defaultValue: Axis.vertical);
          var mainAxisAlignment = MMainAxisAlignment.parse(data.map["align-items"],
              defaultValue: MainAxisAlignment.start);
          var crossAxisAlignment = MCrossAxisAlignment.parse(data.map["justify-content"],
              defaultValue: CrossAxisAlignment.center);

          return GestureDetector(
            onTap: () {
              var bindTap = widget.component.events['bindtap'];
              if (null != bindTap) {
                onTapEvent(widget.pageId, this.hashCode.toString(), data.map, bindTap);
              }
            },
            child: Container(
                key: ObjectKey(widget.component),
                alignment: alignment,
                color: MColor.parse(data.map['background-color']),
                width: MDouble.parse(data.map['width']),
                height: MDouble.parse(data.map['height']),
                margin: MMargin.parse(data.map),
                padding: MPadding.parse(data.map),
                child: data.children.isNotEmpty
                    ? data.children.length > 1
                        ? Flex(
                            direction: direction,
                            children: data.children,
                            mainAxisAlignment: mainAxisAlignment,
                            crossAxisAlignment: crossAxisAlignment,
                          )
                        : data.children[0]
                    : null),
          );
        },
        valueListenable: widget.data);
  }
}
