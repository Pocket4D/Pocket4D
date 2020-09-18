import 'dart:io' show Platform;
import 'package:flutter/widgets.dart';
import 'package:pocket4d/p4d/p4d.dart';
import 'package:thrio/thrio.dart';

class Module
    with
        ThrioModule,
        ModulePageBuilder,
        ModulePageObserver,
        ModuleRouteTransitionsBuilder,
        NavigatorPageObserver {
  @override
  void onPageBuilderRegister() {
    registerPageBuilder(
      '/p4d',
      (settings) {
        var params = Map<String, dynamic>.from(settings.params);
        var endpoint = params["endpoint"];
        var restParams = params;
        restParams.remove("endpoint");

        return P4D(
          bundleApiUrl: endpoint,
          p4dApp: restParams.keys.length == 0 ? null : restParams,
        );
      },
    );
  }

  @override
  void onPageObserverRegister() {
    registerPageObserver(this);
  }

  @override
  void onRouteTransitionsBuilderRegister() {
    // registerRouteTransitionsBuilder(
    //     '\/biz1\/flutter[0-9]*',
    //     (
    //       context,
    //       animation,
    //       secondaryAnimation,
    //       child,
    //     ) =>
    //         SlideTransition(
    //           transformHitTests: false,
    //           position: Tween<Offset>(
    //             begin: const Offset(0, -1),
    //             end: Offset.zero,
    //           ).animate(animation),
    //           child: SlideTransition(
    //             position: Tween<Offset>(
    //               begin: Offset.zero,
    //               end: const Offset(0, 1),
    //             ).animate(secondaryAnimation),
    //             child: child,
    //           ),
    //         ));
  }

  @override
  void onCreate(RouteSettings routeSettings) {}

  @override
  void didAppear(RouteSettings routeSettings) {}

  @override
  void didDisappear(RouteSettings routeSettings) {}

  @override
  void willAppear(RouteSettings routeSettings) {}

  @override
  void willDisappear(RouteSettings routeSettings) {}
}
