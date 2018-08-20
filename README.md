# saltedfish_weibo_plugin

## 新浪微博插件

- 1 目前支持授权和分享
- 2 图片分享待开发
- 3 由于新浪SDK太渣，aar里面so不全，加多了一份arm64-v8a so，请注意适配

## How to use

### 1. Install
Add this to your package's pubspec.yaml file:
```flutter
dependencies:
  saltedfish_weibo_plugin: "^0.0.6"
```
### 2. Import
```flutter
import 'package:saltedfish_weibo_plugin/saltedfish_weibo_plugin.dart';
```

### 3. IOS配置
plist文件
```flutter
<key>LSApplicationQueriesSchemes</key>
    <array>
        <string>sinaweibo</string>
        <string>sinaweibohd</string>
        <string>sinaweibosso</string>
        <string>sinaweibohdsso</string>
        <string>weibosdk</string>
        <string>weibosdk2.5</string>
    </array>
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
    </dict>
```
重写项目的AppDelegate的handleOpenURL和openURL方法
```flutter
// ios 8.x or older
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
     NSString * urlStr = [url absoluteString];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"Weibo" object:nil userInfo:@{@"url":urlStr}];
    return YES;
}
```
```flutter
// ios 9.0+
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
            options:(NSDictionary<NSString*, id> *)options
{
    NSString * urlStr = [url absoluteString];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"Weibo" object:nil userInfo:@{@"url":urlStr}];
    return YES;
}
```
### 4. Use

例子里面也有，可以看example/main.dart

-  初始化
```
SaltedfishWeiboSharePlugin.install('你的appid', '回调地址', '权限');
```
-  web授权

```
SaltedfishWeiboSharePlugin.webAuth();
```
-  sso授权
```
SaltedfishWeiboSharePlugin.ssoAuth();
```
-  all in one授权
```
SaltedfishWeiboSharePlugin.allInOneAuth();
```
-  分享

参数依次为标题，内容，图片(目前仅支持单张，页面地址)
```
 SaltedfishWeiboPlugin.shareToWeibo(
                    '12345678',
                    '2月18日，在各种期待和质疑声中，Apple Pay正式登陆中国，无需联网，甚至不用打开手机屏幕，只要把手机或者iwatch靠近pos机，验证一下指纹，叮咚一声，钱就付了。尽管遭到很多人吐槽：支付三秒钟，绑卡三小时，但令人崩溃的绑卡过程并没减少大家对Apple Pay的热情，据悉，上线第一天Apple Pay的绑卡数量就超过3000万张...',
                    'http://www.17fxw.cn/wts/images/3c21405c29fcdaf7ce6b0ab2c2d4232e','http://www.17fxw.cn/wts/wx/art/detail/7c5b3d90550211e885d8514f3ad721ba');
```
- 状态说明

    0——成功

    -1——取消

    1——失败



## Thanks
 [flutter_wechat][1] [flutter_qq][2]

 [1]: https://github.com/pj0579/flutter_wechat
 [2]: https://github.com/marekchen/flutter_qq
## License
    Copyright 2018 LuoHao

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

