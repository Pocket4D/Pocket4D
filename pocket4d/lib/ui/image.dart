import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
import 'package:pocket4d/entity/component.dart';
import 'package:pocket4d/entity/data.dart';
import 'package:pocket4d/ui/base_widget.dart';
import 'package:pocket4d/ui/basic.dart';
// import 'package:quickjs_dart/quickjs_dart.dart';

class ImageTag extends BaseWidget {
  ImageTag(BaseWidget parent, String pageId, Component component)
      : super(
            parent: parent,
            pageId: pageId,
            component: component,
            data: ValueNotifier(Data(component.properties)));

  @override
  _ImageTagState createState() => _ImageTagState();
}

class _ImageTagState extends State<ImageTag> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        builder: (BuildContext context, Data data, Widget child) {
          var src = data.map['src'].getValue();

          if (null == src || src != 'undefined') {
            return Image.network(src,
                key: ObjectKey(widget.component),
                width: MDouble.parse(data.map['width']),
                height: MDouble.parse(data.map['height']));
          } else {
            return Container(
                key: ObjectKey(widget.component),
                width: MDouble.parse(data.map['width']),
                height: MDouble.parse(data.map['height']));
          }
        },
        valueListenable: widget.data);
  }
}
