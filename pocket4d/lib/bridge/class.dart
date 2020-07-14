import 'dart:async';

import 'package:flutter/services.dart';
import './constant.dart';
import './methods.dart';

class Pocket4d {
  static const MethodChannel _channel = const MethodChannel(channelName);

  static Future<String> get platformVersion async {
    final String version =
        await _channel.invokeMethod(Methods.getPlatformVersion);
    return version;
  }
}
