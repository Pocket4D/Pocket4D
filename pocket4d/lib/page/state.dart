import 'package:dva_dart/dva_dart.dart';

import 'abstract.dart';

enum P4DAppStatus { Loading, Success, Error }

class P4DAppState implements DvaState {
  // MethodChannel _methodChannel = MethodChannel(CHANNEL_METHOD);

  Map<String, String> _pages = Map();
  Map<String, P4DMessageHandler> _handlers = Map();
  String _indexPage;

  Map<String, String> get pages => _pages;
  Map<String, P4DMessageHandler> get handlers => _handlers;

  String get indexPage => _indexPage;

  P4DAppStatus status = P4DAppStatus.Loading;

  P4DAppState.init() {
    status = P4DAppStatus.Loading;
  }
  P4DAppState.loadJson({Map<String, dynamic> json, String indexPage}) {
    json.forEach((k, v) {
      _pages.putIfAbsent(k, () => v.toString());
    });
    _indexPage = indexPage;
    status = P4DAppStatus.Success;
  }

  P4DAppState.removeHandlerById(String pageId) {
    _handlers.remove(pageId);
  }

  @override
  P4DAppState clone() {
    return this;
  }
}
