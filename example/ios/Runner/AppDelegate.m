#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
// ios 8.x or older
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString * urlStr = [url absoluteString];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"Weibo" object:nil userInfo:@{@"url":urlStr}];    return YES;
}

// ios 9.0+
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
            options:(NSDictionary<NSString*, id> *)options
{
    NSString * urlStr = [url absoluteString];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"Weibo" object:nil userInfo:@{@"url":urlStr}];
    return YES;
}

@end
