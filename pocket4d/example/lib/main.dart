import 'package:flutter/material.dart';
import 'package:pocket4d/pocket4d.dart';
import 'package:dva_flutter/dva_flutter.dart';
import 'package:dva_dart/dva_dart.dart';
import 'dart:io' show Platform;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  P4DEngine.start();
  runApp(MyApp());
  P4DEngine.loop();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var url = Platform.isAndroid ? "10.0.2.2" : "127.0.0.1";
    var url = "http://localhost";
    return DvaProvider<DvaStore>(
      child: MaterialApp(
        home: P4D(
          bundleApiUrl: "$url:3001/api/v1/bundled",
        ),
      ),
      store: store,
    );
  }
}
