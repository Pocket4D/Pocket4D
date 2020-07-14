import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pocket4d/entity/component.dart';
import 'package:pocket4d/entity/data.dart';
import 'package:pocket4d/ui/base_widget.dart';
import 'package:pocket4d/ui/basic.dart';

class ImageStateless extends BaseWidget {
  ImageStateless(BaseWidget parent, String pageId, MethodChannel methodChannel,
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
          var src = data.map['src'].getValue();
          if (null == src || src != 'undefined') {
            return Image.network(src,
                key: ObjectKey(component),
                width: MDouble.parse(data.map['width']),
                height: MDouble.parse(data.map['height']));
          } else {
            return Container(
                key: ObjectKey(component),
                width: MDouble.parse(data.map['width']),
                height: MDouble.parse(data.map['height']));
          }
        },
        valueListenable: this.data);
  }
}
