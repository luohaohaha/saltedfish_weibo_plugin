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
                    '12345678',
                    '2月18日，在各种期待和质疑声中，Apple Pay正式登陆中国，无需联网，甚至不用打开手机屏幕，只要把手机或者iwatch靠近pos机，验证一下指纹，叮咚一声，钱就付了。尽管遭到很多人吐槽：支付三秒钟，绑卡三小时，但令人崩溃的绑卡过程并没减少大家对Apple Pay的热情，据悉，上线第一天Apple Pay的绑卡数量就超过3000万张...',
                    'http://www.17fxw.cn/wts/images/3c21405c29fcdaf7ce6b0ab2c2d4232e','http://www.17fxw.cn/wts/wx/art/detail/7c5b3d90550211e885d8514f3ad721ba');
              },
            ),
          ],
        ),
      ),
    );
  }
}
