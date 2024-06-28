#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <Firebase.h>
#import <FirebaseDynamicLinks/FirebaseDynamicLinks.h>
#import <Flutter/Flutter.h>

@implementation AppDelegate {
  FlutterMethodChannel* methodChannel;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [FIRApp configure];
  FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
  methodChannel = [FlutterMethodChannel methodChannelWithName:@"app.stocks.new/dynamic_link" binaryMessenger:controller.binaryMessenger];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
  BOOL handled = [[FIRDynamicLinks dynamicLinks] handleUniversalLink:userActivity.webpageURL
                                                          completion:^(FIRDynamicLink * _Nullable dynamicLink, NSError * _Nullable error) {
    if (error) {
      NSLog(@"Found an error! %@", error.localizedDescription);
      return;
    }
    if (dynamicLink && dynamicLink.url) {
      [self handleIncomingDynamicLink:dynamicLink.url];
    } else {
      [self handleUniversalLink:userActivity.webpageURL];
    }
  }];
  
  return handled || [super application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
}

- (void)handleIncomingDynamicLink:(NSURL *)url {
  if (url) {
    NSLog(@"Your incoming link parameter is: %@", url.absoluteString);
    [methodChannel invokeMethod:@"onDynamicLink" arguments:@{@"link": url.absoluteString}];
  }
}

- (void)handleUniversalLink:(NSURL *)url {
  if (url) {
    NSLog(@"Your incoming universal link parameter is: %@", url.absoluteString);
    [methodChannel invokeMethod:@"onDynamicLink" arguments:@{@"link": url.absoluteString}];
  }
}

@end
