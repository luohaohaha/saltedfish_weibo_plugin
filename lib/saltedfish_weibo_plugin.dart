import 'dart:async';

import 'package:flutter/services.dart';

class SaltedfishWeiboPlugin {
  static const MethodChannel _channel =
  const MethodChannel('saltedfish_weibo_plugin');

  static Future<dynamic> install(
      String appId, String redirectUrl, String scope) async {
    var resultMap = await _channel.invokeMethod('install',
        {'appId': appId, 'redirectUrl': redirectUrl, 'scope': scope});

    return resultMap;
  }

  static Future<dynamic> webAuth() async {
    var resultMap = await _channel.invokeMethod('webAuth');
    return resultMap;
  }

  static Future<dynamic> ssoAuth() async {
    var resultMap = await _channel.invokeMethod('ssoAuth');
    return resultMap;
  }

  static Future<dynamic> allInOneAuth() async {
    var resultMap = await _channel.invokeMethod('allInOneAuth');
    return resultMap;
  }

  static Future<dynamic> shareToWeibo(
      String title, String content, final String imageUrl,String webPageUrl) async {
    var resultMap = await _channel.invokeMethod('shareToWeibo',
        {'title': title, 'content': content, 'imageUrl': imageUrl,'webPageUrl':webPageUrl});
    return resultMap;
  }
}
