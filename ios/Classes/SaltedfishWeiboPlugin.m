#import "SaltedfishWeiboPlugin.h"
#import <saltedfish_weibo_plugin/saltedfish_weibo_plugin-Swift.h>

@implementation SaltedfishWeiboPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSaltedfishWeiboPlugin registerWithRegistrar:registrar];
}
@end
