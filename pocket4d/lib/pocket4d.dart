library pocket4d;

import 'package:dva_dart/dva_dart.dart';
import 'package:dva_flutter/dva_flutter.dart';
import 'package:flutter/material.dart';
import 'package:thrio/thrio.dart';

import 'store.dart';
import 'routes/module.dart' as routes;

export './p4d/engine.dart';
export './p4d/event_manager.dart';
export './p4d/framework.dart';
export './p4d/page_manager.dart';
export './p4d/view_controller.dart';
export './p4d/p4d.dart';
export './page/app.dart';
export './page/container.dart';
export './page/model.dart';
export './page/page.dart';
export './page/state.dart';
export 'store.dart';

class GlobalStore extends StatefulWidget {
  final String entrypoint;

  const GlobalStore({this.entrypoint = ''});

  @override
  _GlobalStoreState createState() => _GlobalStoreState();
}

class _GlobalStoreState extends State<GlobalStore> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DvaProvider<DvaStore>(
      child: MainApp(
        entrypoint: widget.entrypoint,
      ),
      store: store,
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({Key key, String entrypoint = ''})
      : _entrypoint = entrypoint,
        super(key: key);

  final String _entrypoint;

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with ThrioModule {
  @override
  void initState() {
    super.initState();

    registerModule(this);
    initModule();
  }

  @override
  void onModuleRegister() {
    registerModule(routes.Module());
  }

  @override
  void onModuleInit() {
    navigatorLogging = true;
  }

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
        child: MaterialApp(
          builder: ThrioNavigator.builder(entrypoint: widget._entrypoint),
          navigatorObservers: [],
          home: NavigatorHome(),
          theme: ThemeData(
            pageTransitionsTheme: const PageTransitionsTheme(builders: {
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            }),
          ),
        ),
      );
}
