import 'package:flutter/material.dart';

import 'container.dart';

class P4DApp extends StatelessWidget {
  final String bundleApiUrl;
  final String appId;
  final String name;
  final Map<String, dynamic> args;
  P4DApp(this.bundleApiUrl, this.appId, this.name, this.args);
  @override
  Widget build(BuildContext context) {
    return p4dAppContainer(
        context: context, bundleApiUrl: bundleApiUrl, appId: appId, name: name, args: args);
  }
}
