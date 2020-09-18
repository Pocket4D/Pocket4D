import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pocket4d/bean/bundleItem.dart';
import 'package:pocket4d/page/app.dart';
import 'package:pocket4d/services/p4d_http.dart';
import 'package:quickjs_dart/quickjs_dart.dart';
import 'package:thrio/thrio.dart';

class P4D extends StatelessWidget {
  final String bundleApiUrl;
  final dynamic p4dApp;
  P4D({this.bundleApiUrl, this.p4dApp});

  @override
  Widget build(BuildContext context) {
    return P4DIndex(bundleApiUrl: bundleApiUrl, p4dApp: p4dApp);
  }
}

class P4DIndex extends StatefulWidget {
  final String bundleApiUrl;
  final dynamic p4dApp;

  P4DIndex({this.bundleApiUrl, this.p4dApp});

  @override
  _P4DIndexState createState() => _P4DIndexState();
}

class _P4DIndexState extends State<P4DIndex> {
  List<BundleItem> _bundleList = [];
  bool _direct = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.p4dApp == null) {
      fetchAppList(widget.bundleApiUrl);
    } else {
      setState(() {
        _direct = true;
      });
    }
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

  directTo(BuildContext context, dynamic p4dApp) {
    var dataParams = Map<String, dynamic>.from(p4dApp);
    var appId = dataParams["AppId"].toString();
    var name = dataParams["Name"].toString();
    var args = Map<String, dynamic>.from(dataParams["args"] ?? {});
    var newBundleUrl = "${widget.bundleApiUrl}/$appId/$name";
    print("newBundleUrl:$newBundleUrl");
    return P4DApp(newBundleUrl, appId, name, args);
  }

  renderBundleList(BuildContext context) {
    return _bundleList.map((element) {
      return InkWell(
          onTap: () {
            logger.i(element.appId);
            // var newBundleUrl = "${widget.bundleApiUrl}/${element.appId}/${element.name}";
            // Navigator.of(context)
            //     .push(MaterialPageRoute(builder: (context) => P4DApp(newBundleUrl)));
            ThrioNavigator.push(url: '/p4d', params: {
              "AppId": element.appId,
              "Name": element.name,
              "args": {},
              "endpoint": widget.bundleApiUrl
            });
          },
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  element.name,
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  element.appId,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            height: 100,
          ));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _direct == true
        ? directTo(context, widget.p4dApp)
        : Scaffold(
            body: SafeArea(
                child: SingleChildScrollView(
                    child: widget.p4dApp == null
                        ? ListBody(
                            children: _bundleList.length > 0
                                ? renderBundleList(context)
                                : [Text("No App At the moment")],
                          )
                        : Text("Directing"))));
  }
}
