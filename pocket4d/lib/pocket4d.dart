library pocket4d;

import 'package:dio/dio.dart';
import 'package:dva_dart/dva_dart.dart';
import 'package:dva_flutter/dva_flutter.dart';
import 'package:flutter/material.dart';
import 'package:pocket4d/page/app.dart';
import 'package:pocket4d/services/p4d_http.dart';
import 'package:pocket4d/store.dart';
import 'package:quickjs_dart/quickjs_dart.dart';

import 'bean/bundleItem.dart';

export './p4d/engine.dart';
export './p4d/event_manager.dart';
export './p4d/framework.dart';
export './p4d/page_manager.dart';
export './p4d/view_controller.dart';
export './page/app.dart';
export './page/container.dart';
export './page/model.dart';
export './page/page.dart';
export './page/state.dart';
export 'store.dart';

class P4D extends StatelessWidget {
  final DvaStore store;
  final String bundleApiUrl;
  P4D({this.store, this.bundleApiUrl});

  @override
  Widget build(BuildContext context) {

    return P4DIndex(bundleApiUrl: bundleApiUrl);
  }
}

class P4DIndex extends StatefulWidget {
  final String bundleApiUrl;

  P4DIndex({this.bundleApiUrl});

  @override
  _P4DIndexState createState() => _P4DIndexState();
}

class _P4DIndexState extends State<P4DIndex> {
  List<BundleItem> _bundleList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAppList(widget.bundleApiUrl);
  }

  fetchAppList(String url) async {
    Response<dynamic> result = await requestAppList(url);
    List<BundleItem> newList = [];
    if (result.data is List<dynamic>) {
      for (var data in result.data) {
        newList.add(BundleItem.fromJson(data));
      }
    }
    setState(() {
      _bundleList = newList;
    });
  }

  renderBundleList() {
    return _bundleList.map((element) {
      return InkWell(
          onTap: () {
            logger.i(element.appId);
            var newBundleUrl="${widget.bundleApiUrl}/${element.appId}/${element.name}";
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    DvaProvider<DvaStore>(
                      child: P4DApp(newBundleUrl),
                      store: store,
                    )));
          },
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(element.name,style: TextStyle(fontSize: 18),),
              Text(element.appId,style: TextStyle(fontSize: 12),),
            ],),
            height: 100,
          ));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: ListBody(
      children: _bundleList.length > 0
          ? renderBundleList()
          : [Text("No App At the moment")],
    ))));
  }
}
