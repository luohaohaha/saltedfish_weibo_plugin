import 'dart:async';

import 'package:flutter/services.dart';

class SaltedfishWeiboPlugin {
  static const MethodChannel _channel =
      const MethodChannel('saltedfish_weibo_plugin');

  static Future<String> install(String appId, String redirectUrl, String scope ) async {
    final Map<String,String> resultMap = await _channel.invokeMethod('install',{'appId':appId,'redirectUrl':redirectUrl,'scope':scope});

    return resultMap['resultCode'];
  }

  static Future<Map<String,String>> webAuth( ) async {
    final Map<String,String> resultMap = await _channel.invokeMethod('webAuth');
    return resultMap;
  }
  static Future<Map<String,String>> ssoAuth() async {
    final Map<String,String> resultMap = await _channel.invokeMethod('ssoAuth');
    return resultMap;
  }
  static Future<Map<String,String>> allInOneAuth() async {
    final Map<String,String> resultMap = await _channel.invokeMethod('allInOneAuth');
    return resultMap;
  }
  static Future<Map<String,String>> shareToWeibo(String title, String content, final String imageUrl) async {
    final Map<String,String> resultMap = await _channel.invokeMethod('shareToWeibo',{'title':title,'content':content,'imageUrl':imageUrl});
    return resultMap;
  }
}
