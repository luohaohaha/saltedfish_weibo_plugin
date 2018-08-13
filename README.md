# saltedfish_weibo_plugin

## 新浪微博插件

- 1 目前支持授权和分享
- 2 增加了IOS分享，分享的时候预览不显示图片和文字说明，看GITHUB好像是新浪的问题，暂时不做处理，回调还没处理
- 3 由于新浪SDK开发实在太渣，aar没有适配好，所以Android插件放了一份arm64-v8a的so，如果有特殊适配要求的需要自行适配。

## How to use

### 1. Install
Add this to your package's pubspec.yaml file:
```flutter
dependencies:
  saltedfish_weibo_plugin: "^0.0.4"
```
### 2. Import
```flutter
import 'package:saltedfish_weibo_plugin/saltedfish_weibo_plugin.dart';
```



### 3. Use

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

参数依次为标题，内容，图片(目前仅支持单张)
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

