// #import <UIKit/UIKit.h>
// #import <Flutter/Flutter.h>
// #import <Firebase/Firebase.h>
// #import <FirebaseCore/FirebaseCore.h> // Add this import for logging
// #import "GeneratedPluginRegistrant.h" // Add this line

// @interface AppDelegate : FlutterAppDelegate <UNUserNotificationCenterDelegate>
// @end

// @implementation AppDelegate

// - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//     [FIRApp configure];

//     // Set the logger level to debug
//     [FIRConfiguration sharedInstance].loggerLevel = FIRLoggerLevelDebug;

//     [GeneratedPluginRegistrant registerWithRegistry:self];
//     if (@available(iOS 10.0, *)) {
//         [UNUserNotificationCenter currentNotificationCenter].delegate = self;
//     }
//     if (![[NSUserDefaults standardUserDefaults] boolForKey:@"Notification"]) {
//         [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
//         [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Notification"];
//     }
//     return [super application:application didFinishLaunchingWithOptions:launchOptions];
// }

// - (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//     // Handle remote notification received while the app is running
//     [[FIRAuth auth] canHandleNotification:userInfo];
//     completionHandler(UIBackgroundFetchResultNewData);
// }

// @end
// ***************************************************************************

// #import <UIKit/UIKit.h>
// #import <Flutter/Flutter.h>
// #import <Firebase/Firebase.h>
// #import <FirebaseCore/FirebaseCore.h>
// #import "GeneratedPluginRegistrant.h"
// @import BrazeKit;

// static Braze *_braze; // Static variable to hold the Braze instance

// @interface AppDelegate : FlutterAppDelegate <UNUserNotificationCenterDelegate>
// @end

// @implementation AppDelegate

// + (Braze *)braze {
//   return _braze;
// }

// + (void)setBraze:(Braze *)braze {
//   _braze = braze;
// }

// - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//     [FIRApp configure];

//     // Set the logger level to debug
//     [FIRConfiguration sharedInstance].loggerLevel = FIRLoggerLevelDebug;

//     // Configure Braze with your API key and endpoint
//     BRZConfiguration *configuration = [[BRZConfiguration alloc] initWithApiKey:@"6e2560f1-ba23-4958-a4d9-16cd577fcf65"
//                                                                       endpoint:@"sdk.iad-07.braze.com"];
//     [configuration.logger setLevel:BRZLoggerLevelInfo];
//     Braze *braze = [[Braze alloc] initWithConfiguration:configuration];
//     [AppDelegate setBraze:braze]; // Store the Braze instance in the static variable
    
//     [GeneratedPluginRegistrant registerWithRegistry:self];
    
//     if (@available(iOS 10.0, *)) {
//         [UNUserNotificationCenter currentNotificationCenter].delegate = self;
//     }
    
//     // Initialize Flutter method channel
//     FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"brazeMethods"
//                                                              binaryMessenger:self.window.rootViewController];
    
//     // Handle method calls from Flutter using switch case
//     [channel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
//         // Handle the changeUser method call
//         if ([call.method isEqualToString:@"changeUser"]) {
//             NSString *userId = call.arguments[@"userId"];
//             [self changeUser:userId result:result];
//         } else {
//             result(FlutterMethodNotImplemented); // Handle unknown methods
//         }
//     }];
    
//     return [super application:application didFinishLaunchingWithOptions:launchOptions];
// }

// // Method to change user in Braze
// - (void)changeUser:(NSString *)userId result:(FlutterResult)result {
//     if (userId) {
//         [AppDelegate.braze changeUser:userId];
//         result(nil); // No result to return
//     } else {
//         result([FlutterError errorWithCode:@"INVALID_ARGUMENT"
//                                    message:@"User ID cannot be null"
//                                    details:nil]);
//     }
// }

// - (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//     [[FIRAuth auth] canHandleNotification:userInfo];
//     completionHandler(UIBackgroundFetchResultNewData);
// }

// @end



#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>
#import <Firebase/Firebase.h>
#import <FirebaseCore/FirebaseCore.h>
#import "GeneratedPluginRegistrant.h"
@import BrazeKit;

static Braze *_braze; // Static variable to hold the Braze instance

@interface AppDelegate : FlutterAppDelegate <UNUserNotificationCenterDelegate>
@end

@implementation AppDelegate

+ (Braze *)braze {
  return _braze;
}

+ (void)setBraze:(Braze *)braze {
  _braze = braze;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [FIRApp configure];

    // Set the logger level to debug
    [FIRConfiguration sharedInstance].loggerLevel = FIRLoggerLevelDebug;

    // Configure Braze with your API key and endpoint
    BRZConfiguration *configuration = [[BRZConfiguration alloc] initWithApiKey:@"6e2560f1-ba23-4958-a4d9-16cd577fcf65"
                                                                      endpoint:@"sdk.iad-07.braze.com"];
    [configuration.logger setLevel:BRZLoggerLevelInfo];
    Braze *braze = [[Braze alloc] initWithConfiguration:configuration];
    [AppDelegate setBraze:braze]; // Store the Braze instance in the static variable
    
    [GeneratedPluginRegistrant registerWithRegistry:self];
    
    if (@available(iOS 10.0, *)) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    }
    
    // Initialize Flutter method channel
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"brazeMethods"
                                                             binaryMessenger:self.window.rootViewController];
    
    // Handle method calls from Flutter
    [channel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
        if ([call.method isEqualToString:@"changeUser"]) {
            NSString *userId = call.arguments[@"userId"];
            [self changeUser:userId result:result];
        } else if ([call.method isEqualToString:@"addAlias"]) {
            [self handleAddAlias:call result:result];
        } else if ([call.method isEqualToString:@"logCustomEvent"] || [call.method isEqualToString:@"logCustomEventWithProperties"]) {
            [self handleLogCustomEvent:call result:result];
        } else if ([call.method isEqualToString:@"logPurchase"] || [call.method isEqualToString:@"logPurchaseWithProperties"]) {
            [self handleLogPurchase:call result:result];
        } else if ([call.method isEqualToString:@"setFirstName"]) {
            [self handleSetFirstName:call result:result];
        } else if ([call.method isEqualToString:@"setLastName"]) {
            [self handleSetLastName:call result:result];
        } else if ([call.method isEqualToString:@"setCountry"]) {
            [self handleSetCountry:call result:result];
        } else if ([call.method isEqualToString:@"setEmail"]) {
            [self handleSetEmail:call result:result];
        } else if ([call.method isEqualToString:@"setPhoneNumber"]) {
            [self handleSetPhoneNumber:call result:result];
        }  else if ([call.method isEqualToString:@"setWatchlistOrAlert"]) {
            [self handleSetWatchlistOrAlert:call result:result];
        } else if ([call.method isEqualToString:@"setCustomAttribute"]) {
            [self handleSetCustomAttribute:call result:result];  
        }
        else {
            result(FlutterMethodNotImplemented);
        }
    }];
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

#pragma mark - Method Handlers

// Method to change user in Braze
- (void)changeUser:(NSString *)userId result:(FlutterResult)result {
    if (userId) {
        [AppDelegate.braze changeUser:userId];
        result(nil); // No result to return
    } else {
        result([FlutterError errorWithCode:@"INVALID_ARGUMENT"
                                   message:@"User ID cannot be null"
                                   details:nil]);
    }
}

// Method to handle addAlias event
- (void)handleAddAlias:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *args = call.arguments;
    NSString *aliasName = args[@"aliasName"];
    NSString *aliasLabel = args[@"aliasLabel"];
    
    if (aliasName && aliasLabel) {
        [AppDelegate.braze.user addAlias:aliasName label:aliasLabel];
        result(nil);
    } else {
        result([FlutterError errorWithCode:@"INVALID_ARGUMENT"
                                   message:@"Alias name or label is missing"
                                   details:nil]);
    }
}

// Method to handle custom event logging
- (void)handleLogCustomEvent:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *args = call.arguments;
    NSString *eventName = args[@"eventName"];
    NSDictionary *properties = args[@"properties"];
    
    if (eventName) {
        [AppDelegate.braze logCustomEvent:eventName properties:properties];
        result(nil);
    } else {
        result([FlutterError errorWithCode:@"INVALID_ARGUMENT"
                                   message:@"Event name is missing"
                                   details:nil]);
    }
}

// Method to handle purchase logging
- (void)handleLogPurchase:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *args = call.arguments;
    NSString *productId = args[@"productId"];
    NSString *currencyCode = args[@"currencyCode"];
    NSNumber *price = args[@"price"];
    NSNumber *quantity = args[@"quantity"];
    NSDictionary *properties = args[@"properties"];
    
    if (productId && currencyCode && price && quantity) {
        [AppDelegate.braze logPurchase:productId
                              currency:currencyCode
                                 price:[price doubleValue]
                              quantity:[quantity intValue]
                             properties:properties];
        result(nil);
    } else {
        result([FlutterError errorWithCode:@"INVALID_ARGUMENT"
                                   message:@"Missing purchase information"
                                   details:nil]);
    }
}

// Method to set first name
- (void)handleSetFirstName:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *firstName = call.arguments[@"firstName"];
    if (firstName) {
        [AppDelegate.braze.user setFirstName:firstName];
        result(nil);
    } else {
        result([FlutterError errorWithCode:@"INVALID_ARGUMENT"
                                   message:@"First name is missing"
                                   details:nil]);
    }
}

// Method to set last name
- (void)handleSetLastName:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *lastName = call.arguments[@"lastName"];
    if (lastName) {
        [AppDelegate.braze.user setLastName:lastName];
        result(nil);
    } else {
        result([FlutterError errorWithCode:@"INVALID_ARGUMENT"
                                   message:@"Last name is missing"
                                   details:nil]);
    }
}

// Method to set country
- (void)handleSetCountry:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *country = call.arguments[@"country"];
    if (country) {
        [AppDelegate.braze.user setCountry:country];
        result(nil);
    } else {
        result([FlutterError errorWithCode:@"INVALID_ARGUMENT"
                                   message:@"Country is missing"
                                   details:nil]);
    }
}

// Method to set email
- (void)handleSetEmail:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *email = call.arguments[@"email"];
    if (email) {
        [AppDelegate.braze.user setEmail:email];
        result(nil);
    } else {
        [AppDelegate.braze.user setEmail:nil]; // Handle null email
        result(nil);
    }
}

// Method to set phone number
- (void)handleSetPhoneNumber:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *phoneNumber = call.arguments[@"phoneNumber"];
    if (phoneNumber) {
        [AppDelegate.braze.user setPhoneNumber:phoneNumber];
        result(nil);
    } else {
        result([FlutterError errorWithCode:@"INVALID_ARGUMENT"
                                   message:@"Phone number is missing"
                                   details:nil]);
    }
}

// Method to set Watchlist or Alerts
- (void)handleSetWatchlistOrAlert:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *eventName = call.arguments[@"eventName"];  // Can be "watchlists" or "alerts"
    NSArray *tickers = call.arguments[@"tickers"];  // Array of stock tickers
    
    if (eventName && tickers) {
        if ([eventName isEqualToString:@"watchlists"] || [eventName isEqualToString:@"alerts"]) {
            // Set the watchlist or alerts custom attribute with the provided tickers
            [AppDelegate.braze.user setCustomAttributeArrayWithKey:eventName array:tickers];
            result(nil);  // Successfully set the custom attribute
        } else {
            result([FlutterError errorWithCode:@"INVALID_ARGUMENT"
                                       message:@"Invalid event name"
                                       details:nil]);
        }
    } else {
        result([FlutterError errorWithCode:@"INVALID_ARGUMENT"
                                   message:@"Event name or tickers are missing"
                                   details:nil]);
    }
}
   
// Method to set custom attribute (string or integer)
- (void)handleSetCustomAttribute:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *args = call.arguments;
    NSString *key = args[@"key"];
    id value = args[@"value"];  // Dynamic type to handle string, integer, or array
    
    if (key && value) {
        // If value is a string
        if ([value isKindOfClass:[NSString class]]) {
            [AppDelegate.braze.user setCustomAttributeWithKey:key stringValue:value];
        } 
        // If value is an integer
        else if ([value isKindOfClass:[NSNumber class]]) {
            [AppDelegate.braze.user setCustomAttributeWithKey:key andIntegerValue:[value intValue]];
        } 
        else {
            result([FlutterError errorWithCode:@"INVALID_ARGUMENT"
                                       message:@"Value must be a string or an integer"
                                       details:nil]);
            return;
        }
        result(nil);  // Successfully set the custom attribute
    } else {
        result([FlutterError errorWithCode:@"INVALID_ARGUMENT"
                                   message:@"Key or value is missing for custom attribute"
                                   details:nil]);
    }
}

@end
