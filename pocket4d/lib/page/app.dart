import 'package:flutter/material.dart';

import 'container.dart';

class P4DApp extends StatelessWidget {
  final String bundleApiUrl;
  final String indexKey;
  P4DApp(this.bundleApiUrl, this.indexKey);
  @override
  Widget build(BuildContext context) {
    return p4dAppContainer(context: context, bundleApiUrl: bundleApiUrl, indexKey: indexKey);
  }
}
