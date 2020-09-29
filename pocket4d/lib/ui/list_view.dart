import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:pocket4d/entity/component.dart';
import 'package:pocket4d/entity/data.dart';
import 'package:pocket4d/util/event_util.dart';
// import 'package:quickjs_dart/quickjs_dart.dart';

import 'base_widget.dart';
import 'basic.dart';

class ListViewTag extends BaseWidget {
  ListViewTag(BaseWidget parent, String pageId, Component component)
      : super(
            parent: parent,
            pageId: pageId,
            component: component,
            data: ValueNotifier(Data(component.properties)));

  @override
  _ListViewTagState createState() => _ListViewTagState();
}

class _ListViewTagState extends State<ListViewTag> {
  void _scrollToUpper() {
    var upper = widget.component.events["bindscrolltoupper"];
    if (null != upper) {
      onScrollLimitEvent(widget.pageId, widget.component.id, upper);
    }
  }

  void _scrollToLower() {
    var lower = widget.component.events["bindscrolltolower"];
    if (null != lower) {
      onScrollLimitEvent(widget.pageId, widget.component.id, lower);
    }
  }

  void _scroll(double pixels) {
    var bindScroll = widget.component.events["bindscroll"];
    if (null != bindScroll) {
      onScrollEvent(widget.pageId, widget.component.id, bindScroll, pixels);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      key: ObjectKey(widget.component),
      child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            if (notification is ScrollEndNotification) {
              if (notification.metrics.pixels == notification.metrics.minScrollExtent) {
                _scrollToUpper();
              } else if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
                _scrollToLower();
              }
              _scroll(notification.metrics.pixels);
            }
            return true; // 返回false可见滚动条
          },
          child: ValueListenableBuilder(
              builder: (BuildContext context, Data data, Widget child) {
                return ListView(
                    key: UniqueKey(),
                    scrollDirection:
                        MAxis.parse(data.map["scroll-direction"], defaultValue: Axis.vertical),
                    reverse: MBool.parse(data.map["reverse"], defaultValue: false),
//              controller: _scrollController,
                    primary: MBool.parse(data.map["primary"]),
//                  physics: data.map["physics"],
                    shrinkWrap: MBool.parse(data.map["shrink-wrap"], defaultValue: false),
                    padding: MPadding.parse(data.map),
                    itemExtent: MDouble.parse(data.map["item-extent"]),
                    addAutomaticKeepAlives:
                        MBool.parse(data.map["add-automatic-keep-alives"], defaultValue: true),
                    addRepaintBoundaries:
                        MBool.parse(data.map["add-repaint-boundaries"], defaultValue: true),
                    addSemanticIndexes:
                        MBool.parse(data.map["add-semantic-indexes"], defaultValue: true),
                    cacheExtent: MDouble.parse(data.map["cache-extent"]),
                    children: data.children,
                    semanticChildCount: MInt.parse(data.map["semantic-child-count"]));
              },
              valueListenable: widget.data)),
    );
  }
}
