import 'package:flutter/material.dart';

import 'container.dart';

class P4DApp extends StatelessWidget {
  final String bundleApiUrl;
  P4DApp(this.bundleApiUrl);
  @override
  Widget build(BuildContext context) {
    return p4dAppContainer(context: context, bundleApiUrl: bundleApiUrl);
  }
}
