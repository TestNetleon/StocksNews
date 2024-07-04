#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
@import Firebase;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [FIRApp configure];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  
  if (@available(iOS 10.0, *)) {
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
  }
  
  if (![[NSUserDefaults standardUserDefaults] boolForKey:@"Notification"]) {
    [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Notification"];
  }
  
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  [super application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
  
  // Check if Firebase Messaging can handle the notification
  if ([[FIRMessaging messaging] appDidReceiveMessage:userInfo]) {
    completionHandler(UIBackgroundFetchResultNoData);
  } else {
    // Handle your custom notification handling logic here
    NSLog(@"Received remote notification: %@", userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
  }
}

@end
