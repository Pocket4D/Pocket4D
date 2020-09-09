library pocket4d;

import 'package:dva_dart/dva_dart.dart';
import 'package:dva_flutter/dva_flutter.dart';
import 'package:flutter/material.dart';
import 'package:pocket4d/page/app.dart';

export './bridge/class.dart';
export './bridge/constant.dart';
export './bridge/methods.dart';

export './p4d/engine.dart';
export './p4d/view_controller.dart';
export './p4d/framework.dart';
export './p4d/page_manager.dart';
export './p4d/event_manager.dart';

export './page/app.dart';
export './page/container.dart';
export './page/model.dart';
export './page/page.dart';
export './page/state.dart';

export 'store.dart';

class P4D extends StatelessWidget {
  final DvaStore store;
  final String bundleApiUrl;
  final String indexKey;

  P4D({this.store, this.bundleApiUrl, this.indexKey});
  @override
  Widget build(BuildContext context) {
    return DvaProvider<DvaStore>(
      child: P4DApp(bundleApiUrl, indexKey),
      store: store,
    );
  }
}

class WarmupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "warming up!",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
