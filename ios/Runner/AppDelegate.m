 #import <UIKit/UIKit.h>
 #import <Flutter/Flutter.h>
 #import <Firebase/Firebase.h>
 #import "GeneratedPluginRegistrant.h" // Add this line

 @interface AppDelegate : FlutterAppDelegate <UNUserNotificationCenterDelegate>
 @end
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
    // Handle remote notification received while the app is running
    [[FIRAuth auth] canHandleNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
@end
