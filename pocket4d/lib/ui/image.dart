import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
import 'package:pocket4d/entity/component.dart';
import 'package:pocket4d/entity/data.dart';
import 'package:pocket4d/ui/base_widget.dart';
import 'package:pocket4d/ui/basic.dart';
// import 'package:quickjs_dart/quickjs_dart.dart';

class ImageStateless extends BaseWidget {
  ImageStateless(BaseWidget parent, String pageId, Component component)
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
          var src = data.map['src'].getValue();

          if (null == src || src != 'undefined') {

            return Image.network(src,
                key: ObjectKey(component),
                width: MDouble.parse(data.map['width'])??100,
                height: MDouble.parse(data.map['height'])??100);
          } else {
            return Container(
                key: ObjectKey(component),
                width: MDouble.parse(data.map['width'])??100,
                height: MDouble.parse(data.map['height'])??100);
          }
        },
        valueListenable: this.data);
  }
}
