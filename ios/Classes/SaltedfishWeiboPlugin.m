#import "SaltedfishWeiboPlugin.h"
#import "WeiboSDK.h"

@implementation SaltedfishWeiboPlugin

{
    NSString *_redirectUrl;
    FlutterResult res;
}
- (instancetype)init
{
    self = [super init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleOpenURL:)
                                                 name:@"Weibo"
                                               object:nil];
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"saltedfish_weibo_plugin"
                                     binaryMessenger:[registrar messenger]];
    SaltedfishWeiboPlugin* instance = [[SaltedfishWeiboPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    res = result;
    //  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    //    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    //  } else {
    //    result(FlutterMethodNotImplemented);
    //  }
    if ([@"install" isEqualToString:call.method]) {
        [self install:call];
        _redirectUrl = call.arguments[@"redirectUrl"];
        
    }
    else if([@"webAuth" isEqualToString:call.method] ||[@"ssoAuth" isEqualToString:call.method] ||[@"allInOneAuth" isEqualToString:call.method]){
        [self auth:call];
        
    }
    else if([@"shareToWeibo" isEqualToString:call.method]){
        [self shareToWeibo:call];
    }
}

- (void)install:(FlutterMethodCall*)call{
    NSMutableDictionary *dic =  [NSMutableDictionary dictionary];
    [dic setValue:@"install" forKey:@"type"];
    BOOL success = [WeiboSDK registerApp:call.arguments[@"appId"]];
    [WeiboSDK enableDebugMode:YES];
    [dic setValue:@"install" forKey:@"type"];
    [dic setValue:success?@"0":@"1" forKey:@"resultCode"];
    res(dic);
}

- (void)auth:(FlutterMethodCall*)call{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = _redirectUrl;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
    
}

- (void) shareToWeibo:(FlutterMethodCall*)call{
    WBMessageObject * message =[WBMessageObject message];
    // 消息中包含的网页数据对象
    WBWebpageObject * webpage =[WBWebpageObject object];
    // 对象唯一ID，用于唯一标识一个多媒体内容
    // 当第三方应用分享多媒体内容到微博时，应该将此参数设置为被分享的内容在自己的系统中的唯一标识
    webpage.objectID = @"identifier1";
    webpage.title = [NSString stringWithFormat:@"%@\n%@",call.arguments[@"title"],call.arguments[@"content"]];
    webpage.webpageUrl = call.arguments[@"webPageUrl"];
    //    webpage.description = call.arguments[@"content"];
    
    // 多媒体内容缩略图
    NSData* data=[NSData dataWithContentsOfURL:[NSURL URLWithString:call.arguments[@"imageUrl"]]];
    webpage.thumbnailData = [self compressImage:[UIImage imageWithData:data] toByte:32768];
    // 网页的url地址
    // webpage.webpageUrl = @"http://sina.cn?a=1";
    // 消息的多媒体内容
    message.mediaObject = webpage;
    //    WBImageObject *image = [WBImageObject object];
    //    image.imageData =[NSData dataWithContentsOfURL :[NSURL URLWithString : call.arguments[@"imageUrl"]]];
    //    message.imageObject = image;
    WBSendMessageToWeiboRequest * request =[WBSendMessageToWeiboRequest requestWithMessage : message authInfo : nil access_token : nil];
    [WeiboSDK sendRequest : request];
}

-(BOOL)handleOpenURL:(NSNotification *)aNotification
{
    NSString * aURLString =  [aNotification userInfo][@"url"];
    NSURL * aURL = [NSURL URLWithString:aURLString];
    return [WeiboSDK handleOpenURL:aURL delegate:self];
    
}

#pragma mark - 压缩图片
-(NSData *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return data;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return data;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return data;
}

#pragma mark -- WeiboSDKDelegate
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    NSLog(@"%ld", response.statusCode);
    
    int statuCode = response.statusCode;
    NSMutableDictionary *dic =  [NSMutableDictionary dictionary];
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        [dic setValue:@"share" forKey:@"type"];
        //cancel
        if(-1 == statuCode){
            [dic setValue:@"-1" forKey:@"resultCode"];
            [dic setValue:@"分享取消" forKey:@"resultMsg"];
            res(dic);
            
          
        }else if(0 == statuCode){
            [dic setValue:@"0" forKey:@"resultCode"];
            res(dic);
        }else{
            [dic setValue:[NSString stringWithFormat:@"%d", statuCode] forKey:@"resultCode"];
            [dic setValue:@"分享错误" forKey:@"resultMsg"];
            res(dic);
        }
        
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        [dic setValue:@"auth" forKey:@"type"];
        if(-1 == statuCode){
            [dic setValue:@"-1" forKey:@"resultCode"];
            [dic setValue:@"授权取消" forKey:@"resultMsg"];
            res(dic);
            
            
        }else if(0 == statuCode){
            [dic setValue:@"0" forKey:@"resultCode"];
            [dic setValue:[(WBAuthorizeResponse *)response accessToken] forKey:@"resultMsg"];
            res(dic);
        }else{
            [dic setValue:[NSString stringWithFormat:@"%d", statuCode] forKey:@"resultCode"];
            [dic setValue:@"授权错误" forKey:@"resultMsg"];
            res(dic);
        }
    }
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

@end



