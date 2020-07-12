import 'dart:async';

import 'package:flutter/services.dart';

class Pocket4d {
  static const MethodChannel _channel =
      const MethodChannel('pocket4d');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
