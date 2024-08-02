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

// ******************************** Working but crashing sometimes ********************************

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

//  - (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//      [super application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
//      FIRAuth *firebaseAuth = [FIRAuth auth];
//      [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
//      NSLog(@"%@", userInfo);
//      if ([firebaseAuth canHandleNotification:userInfo]) {
//              // Ensure completion handler is called on the main thread
//              dispatch_async(dispatch_get_main_queue(), ^{
//                  completionHandler(UIBackgroundFetchResultNoData);
//              });
//              return;
//          }
//          // If you have other tasks to handle, do them here and then call the completion handler.
//          // Ensure completion handler is called in all code paths
//          dispatch_async(dispatch_get_main_queue(), ^{
//              completionHandler(UIBackgroundFetchResultNewData); // Or the appropriate result
//          });
//  }
 @end


// ***************************************************************************


// #import <UIKit/UIKit.h>
// #import <Flutter/Flutter.h>
// #import <Firebase/Firebase.h>
// #import "GeneratedPluginRegistrant.h"
// @interface AppDelegate : FlutterAppDelegate <UNUserNotificationCenterDelegate>
// @end
// @implementation AppDelegate
// - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//   [FIRApp configure];
//   [GeneratedPluginRegistrant registerWithRegistry:self];
//   if (@available(iOS 10.0, *)) {
//     [UNUserNotificationCenter currentNotificationCenter].delegate = self;
//   }
//   if (![[NSUserDefaults standardUserDefaults] boolForKey:@"Notification"]) {
//     [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
//     [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Notification"];
//   }
//   return [super application:application didFinishLaunchingWithOptions:launchOptions];
// }
// - (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//   [super application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
//   FIRAuth *firebaseAuth = [FIRAuth auth];
//   [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
//   NSLog(@"%@", userInfo);
//   // Remove the commented-out line below if Firebase Auth doesn't handle notifications
//   // if ([firebaseAuth canHandleNotification:userInfo]) { ... }
//   // Your custom logic for handling all notifications goes here
//   // ... (replace with your code for handling both Firebase Auth and non-Firebase Auth notifications)
//   // ...
//   // Ensure completion handler is called with an appropriate result
//   dispatch_async(dispatch_get_main_queue(), ^{
//     completionHandler(UIBackgroundFetchResultNewData); // Or the appropriate result based on your logic
//   });
// }
// @end


// *******************************************************************************

//#import <UIKit/UIKit.h>
//#import <Flutter/Flutter.h>
//#import <Firebase/Firebase.h>
//#import "GeneratedPluginRegistrant.h"
//
//@interface AppDelegate : FlutterAppDelegate <UNUserNotificationCenterDelegate>
//@end
//
//@implementation AppDelegate
//
//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//  [FIRApp configure];
//  [GeneratedPluginRegistrant registerWithRegistry:self];
//  
//  if (@available(iOS 10.0, *)) {
//    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
//  }
//  
//  if (![[NSUserDefaults standardUserDefaults] boolForKey:@"Notification"]) {
//    [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Notification"];
//  }
//  
//  return [super application:application didFinishLaunchingWithOptions:launchOptions];
//}
//
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//  [super application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
//  FIRAuth *firebaseAuth = [FIRAuth auth];
//  [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
//  NSLog(@"%@", userInfo);
//  
//  if ([firebaseAuth canHandleNotification:userInfo]) {
//    // Ensure completion handler is called on the main thread
//    dispatch_async(dispatch_get_main_queue(), ^{
//      completionHandler(UIBackgroundFetchResultNoData   );
//    });
//    return;
//  }
//  
//  // If Firebase Auth cannot handle the notification, your custom logic goes here
//  // ... (replace with your code for handling non-Firebase Auth notifications)
//  // ...
//  
//  // Ensure completion handler is called with an appropriate result
//  dispatch_async(dispatch_get_main_queue(), ^{
//    completionHandler(UIBackgroundFetchResultNewData); // Or the appropriate result based on your logic
//  });
//}
//
//@end
