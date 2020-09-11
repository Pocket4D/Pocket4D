import 'package:event_bus/event_bus.dart';

class EventManager {
  static const TYPE_SOCKET = 0;
  static const TYPE_REFRESH = 1;
  static const TYPE_NAVIGATION_BAR_TITLE = 2;
  static const TYPE_NAVIGATE_TO = 3;
  static const TYPE_NAVIGATION_BAR_COLOR = 4;
  static const TYPE_BACKGROUND_COLOR = 5;
  static const TYPE_TOGGLE_LOADING = 6;
  static const TYPE_TOGGLE_TOAST = 7;
  static const TYPE_TOGGLE_PULL_DOWN_REFRESH = 8;


  static final EventBus eventBus = EventBus(sync: true);

  static Map<String, dynamic> sendMessage(
      int type, String pageId, dynamic obj) {
    Map<String, dynamic> message = Map();
    message.putIfAbsent("type", () => type);
    message.putIfAbsent("pageId", () => pageId);
    message.putIfAbsent("message", () => obj);
    return message;
  }
}
