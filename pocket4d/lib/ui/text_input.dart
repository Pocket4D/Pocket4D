import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pocket4d/entity/component.dart';
import 'package:pocket4d/entity/data.dart';
import 'package:pocket4d/ui/base_widget.dart';
import 'package:pocket4d/ui/basic.dart';
import 'package:pocket4d/util/color_util.dart';
import 'package:pocket4d/util/event_util.dart';

class TextFieldTag extends BaseWidget {
  TextFieldTag(BaseWidget parent, String pageId, Component component)
      : super(
            parent: parent,
            pageId: pageId,
            component: component,
            data: ValueNotifier(Data(component.properties)));

  @override
  _TextFieldTagState createState() => _TextFieldTagState();
}

class _TextFieldTagState extends State<TextFieldTag> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        builder: (BuildContext context, Data data, Widget child) {
          _controller.text = MString.parse(data.map['value'], defaultValue: null);

          return TextField(
              controller: _controller,
              onChanged: (value) {
                var bindInput = widget.component.events['bindinput'];
                if (null != bindInput) {
                  onInputEvent(widget.pageId, widget.component.id, bindInput, value);
                }
              },
              onTap: () {
                var bindFocus = widget.component.events['onfocus'];
                if (null != bindFocus) {
                  onFocusEvent(widget.pageId, widget.component.id, bindFocus);
                }
              },
              onSubmitted: (value) {
                var bindconfirm = widget.component.events['bindconfirm'];
                if (null != bindconfirm) {
                  onConfirmEvent(widget.pageId, widget.component.id, bindconfirm, value);
                }
              },
              obscureText:
                  MBool.parse(widget.component.properties["password"], defaultValue: false),
              decoration: InputDecoration(
                hintText:
                    MString.parse(widget.component.properties["placeholder"], defaultValue: null),
                errorText:
                    MString.parse(widget.component.properties["errorText"], defaultValue: null),
              ),
              keyboardType: getInputType(widget.component),
              enabled: !MBool.parse(widget.component.properties["disabled"], defaultValue: false),
              maxLength: MInt.parse(widget.component.properties["maxlength"], defaultValue: 140),
              autofocus: MBool.parse(widget.component.properties["focus"], defaultValue: false),

              // cursorHeight: MDouble.parse(component.properties["cursor-spacing"], defaultValue: 0),
              key: ObjectKey(widget.component),
              style: TextStyle(
                  inherit: MBool.parse(data.map['inherit'], defaultValue: true),
                  fontSize: MDouble.parse(data.map['font-size'], defaultValue: 14),
                  backgroundColor: dealColor(data.map['background-color']),
                  color: dealFontColor(data.map['color'])));
        },
        valueListenable: widget.data);
  }

  TextInputType getInputType(Component component) {
    String inputType = MString.parse(component.properties["type"], defaultValue: "text");
    switch (inputType) {
      case 'text':
        return TextInputType.text;
      case 'number':
        return TextInputType.number;
      case 'url':
        return TextInputType.url;
      case 'email':
        return TextInputType.emailAddress;
      case 'phone':
        return TextInputType.phone;
      default:
        return TextInputType.text;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
