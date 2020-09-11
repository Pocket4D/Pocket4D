import 'package:flutter/material.dart';
import 'package:pocket4d/pocket4d.dart';
import 'dart:io' show Platform;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  P4DEngine.start();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var url = Platform.isAndroid ? "10.0.2.2" : "127.0.0.1";
    return MaterialApp(
      home: P4D(
        store: store,
        bundleApiUrl: "http://$url:3001/api/v1/bundled",
      ),
    );
  }
}
