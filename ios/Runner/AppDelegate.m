// #import "AppDelegate.h"
// #import "GeneratedPluginRegistrant.h"
// @import Firebase;

// @implementation AppDelegate

// - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//   [FIRApp configure];
//   [GeneratedPluginRegistrant registerWithRegistry:self];
  
//   // if (@available(iOS 10.0, *)) {
//   //   [UNUserNotificationCenter currentNotificationCenter].delegate = self;
//   // }
  
//   // if (![[NSUserDefaults standardUserDefaults] boolForKey:@"Notification"]) {
//   //   [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
//   //   [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Notification"];
//   // }
  
//   return [super application:application didFinishLaunchingWithOptions:launchOptions];
// }

// // - (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
// //   [super application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
  
// //   // Check if Firebase Messaging can handle the notification
// //   if ([[FIRMessaging messaging] appDidReceiveMessage:userInfo]) {
// //     completionHandler(UIBackgroundFetchResultNoData);
// //   } else {
// //     // Handle your custom notification handling logic here
// //     NSLog(@"Received remote notification: %@", userInfo);
// //     completionHandler(UIBackgroundFetchResultNewData);
// //   }
// // }

// @end
#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>
#import <Firebase/Firebase.h>
#import "GeneratedPluginRegistrant.h"  // Add this line

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
    [super application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
    FIRAuth *firebaseAuth = [FIRAuth auth];
    [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    NSLog(@"%@", userInfo);
    
//    if ([firebaseAuth canHandleNotification:userInfo]) {
//        completionHandler(UIBackgroundFetchResultNoData);
//        return;
//    }
    if ([firebaseAuth canHandleNotification:userInfo]) {
            // Ensure completion handler is called on the main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(UIBackgroundFetchResultNoData);
            });
            return;
        }
        
        // If you have other tasks to handle, do them here and then call the completion handler.
        
        // Ensure completion handler is called in all code paths
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(UIBackgroundFetchResultNewData); // Or the appropriate result
        });
}

@end
