# saltedfish_weibo_plugin

## 新浪微博插件

- 1 目前支持授权和分享
- 2 由于本人是Android开发，不熟悉OC，所以暂时不支持IOS，空余时间会用Swift补上IOS，时间未知，如果有小伙伴能帮忙补全就最好不过了。
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
SaltedfishWeiboSharePlugin.shareToWeibo('我有一个小小的愿望，就是想和你……', '幸福，不是有多大的房子，也不是有多豪的车，幸福是生活中每个微小的愿望都成真。\n对于幸福的定义，不同的人有不同的理解于我而言，幸福就是和你一起去旅行。', 'http://www.17fxw.cn:4869/3efb5cfc0554461e18acf255cfd16733');
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

