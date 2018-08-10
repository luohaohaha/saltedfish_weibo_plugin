import 'package:flutter/material.dart';
import 'package:saltedfish_weibo_plugin/saltedfish_weibo_plugin.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String WTS_SHARE_SINA_APP_KEY = "4078126022";
  final String WTS_SHARE_SINA_REDIRECT_URL = "http://www.17fxw.cn/";
  final String WTS_SHARE_SINA_SCOPE =
      "email,direct_messages_read,direct_messages_write,friendships_groups_read,friendships_groups_write,statuses_to_me_read,follow_app_official_microblog,invitation_write";

  @override
  void initState() {
    super.initState();
    SaltedfishWeiboPlugin.install(WTS_SHARE_SINA_APP_KEY,
        WTS_SHARE_SINA_REDIRECT_URL, WTS_SHARE_SINA_SCOPE);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Column(
          children: <Widget>[
            InkWell(
              child: Container(
                child: Text('web授权'),
                padding: EdgeInsets.all(16.0),
              ),
              onTap: () {
                SaltedfishWeiboPlugin.webAuth();
              },
            ),
            InkWell(
              child: Container(
                child: Text('sso授权'),
                padding: EdgeInsets.all(16.0),
              ),
              onTap: () {
                SaltedfishWeiboPlugin.ssoAuth();
              },
            ),
            InkWell(
              child: Container(
                child: Text('all in one'),
                padding: EdgeInsets.all(16.0),
              ),
              onTap: () {
                SaltedfishWeiboPlugin.allInOneAuth();
              },
            ),
            InkWell(
              child: Container(
                child: Text('分享'),
                padding: EdgeInsets.all(16.0),
              ),
              onTap: () {
                SaltedfishWeiboPlugin.shareToWeibo(
                    '我有一个小小的愿望，就是想和你……',
                    '幸福，不是有多大的房子，也不是有多豪的车，幸福是生活中每个微小的愿望都成真。\n对于幸福的定义，不同的人有不同的理解于我而言，幸福就是和你一起去旅行。',
                    'http://www.17fxw.cn:4869/3efb5cfc0554461e18acf255cfd16733');
              },
            ),
          ],
        ),
      ),
    );
  }
}
