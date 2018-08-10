#import "SaltedfishWeiboPlugin.h"
#import "WeiboSDK.h"
    @implementation SaltedfishWeiboPlugin{
  FlutterResult res;
}
    + (void)registerWithRegistrar : (NSObject < FlutterPluginRegistrar > * )registrar {
  FlutterMethodChannel * channel =[FlutterMethodChannel
methodChannelWithName :@"saltedfish_weibo_plugin"
binaryMessenger :[registrar messenger]];
SaltedfishWeiboPlugin * instance =[[SaltedfishWeiboPlugin alloc]init];
[registrar addMethodCallDelegate : instance channel : channel];
}
- (void)handleMethodCall : (FlutterMethodCall *)call result : (FlutterResult)result {
  res = result;
  NSDictionary * arguments =[call arguments];
  if ([@"install"isEqualToString : call.method]) {

// [WeiboSDK enableDebugMode : YES];
// [WeiboSDK registerApp :@"4078126022"];

}
else if([@"webAuth"isEqualToString : call.method] || [@"ssoAuth"isEqualToString : call.method] || [@"allInOneAuth"isEqualToString : call.method]){
  WBAuthorizeRequest * authRequest =[WBAuthorizeRequest request];
// 微博开放平台第三方应用授权回调页地址，默认为`http : // `
authRequest.redirectURI = @"http://www.sina.com";

    // 微博开放平台第三方应用 scope，多个 scope 用逗号分隔
authRequest.scope = @"all";
    // 第三方应用发送消息至微博客户端程序的消息结构体，其中 message 类型我会在下面放出
[WeiboSDK sendRequest : authRequest];
}
else if([@"shareToWeibo"isEqualToString : call.method]){

  WBMessageObject * message =[WBMessageObject message];
// 消息中包含的网页数据对象
WBWebpageObject * webpage =[WBWebpageObject object];
// 对象唯一ID，用于唯一标识一个多媒体内容
    // 当第三方应用分享多媒体内容到微博时，应该将此参数设置为被分享的内容在自己的系统中的唯一标识
webpage.objectID = @"identifier1";
webpage.title = arguments[@"title"];
webpage.description = arguments[@"content"];
// 多媒体内容缩略图
webpage.thumbnailData =[NSData dataWithContentsOfURL :[NSURL URLWithString : arguments[@"imageUrl"]]];
// 网页的url地址
    // webpage.webpageUrl = @"http://sina.cn?a=1";
    // 消息的多媒体内容
message.mediaObject = webpage;
WBSendMessageToWeiboRequest * request =[WBSendMessageToWeiboRequest requestWithMessage : message authInfo : nil access_token : nil];
[WeiboSDK sendRequest : request];
}
}

- (BOOL)application : (UIApplication *)application handleOpenURL : (NSURL *)url
{
  return[WeiboSDK handleOpenURL : url delegate : self ];
}
    - (BOOL)application : (UIApplication *)application didFinishLaunchingWithOptions : (NSDictionary *)launchOptions{
[WeiboSDK enableDebugMode : YES];
[WeiboSDK registerApp :@"4078126022"];
return true;
}
@end
