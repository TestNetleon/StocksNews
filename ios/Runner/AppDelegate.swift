import BrazeKit
import BrazeUI
import Flutter
import UIKit
import braze_plugin
import Firebase
import UserNotifications
import FirebaseMessaging
import StoreKit

//LOCAL
// let brazeApiKey = "ba184694-cb2b-4e70-9e00-1e300ca9ecb0"

//LIVE
let brazeApiKey = "6e2560f1-ba23-4958-a4d9-16cd577fcf65"

let brazeEndpoint = "sdk.iad-07.braze.com"

@main
@objc class AppDelegate: FlutterAppDelegate, BrazeInAppMessageUIDelegate {

  // These subscriptions need to be retained to be active
  var pushEventsSubscription: Braze.Cancellable?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    FirebaseApp.configure()
    FirebaseConfiguration.shared.setLoggerLevel(.debug)
    // Request permission for push notifications
    UNUserNotificationCenter.current().requestAuthorization(
      options: [.alert, .badge, .sound]
    ) { granted, error in
      if granted {
        print("Permission granted for notifications.")
      } else if let error = error {
        print("Error requesting permission: \(error.localizedDescription)")
      }
    }
    
    // Register for remote notifications
    application.registerForRemoteNotifications()

    GeneratedPluginRegistrant.register(with: self)

    // - Setup Braze
    let configuration = Braze.Configuration(apiKey: brazeApiKey, endpoint: brazeEndpoint)
    configuration.sessionTimeout = 1
    configuration.triggerMinimumTimeInterval = 0

    configuration.logger.level = .debug

    // - Automatic push notification setup
    configuration.push.automation = true

    let braze = BrazePlugin.initBraze(configuration)

  // Check if a cached device token exists
  if let cachedDeviceToken = UserDefaults.standard.data(forKey: "cachedDeviceToken") {
      BrazePlugin.braze?.notifications.register(deviceToken: cachedDeviceToken)
      print("Token registered with Braze from cache")
  }

    // - InAppMessage UI
    let inAppMessageUI = BrazeInAppMessageUI()
    inAppMessageUI.delegate = self
    // let inAppMessageUI = CustomInAppMessagePresenter()
    braze.inAppMessagePresenter = inAppMessageUI


    pushEventsSubscription = braze.notifications.subscribeToUpdates { payload in
      print(
        """
        => [Push Event Subscription] Received push event:
           - type: \(payload.type)
           - title: \(payload.title ?? "<empty>")
           - isSilent: \(payload.isSilent)
        """
      )
      BrazePlugin.processPushEvent(payload)
    }
    // Set Braze user notification center delegate
    UNUserNotificationCenter.current().delegate = self

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    // Handle foreground notifications
  override  func userNotificationCenter(_ center: UNUserNotificationCenter,
                                 willPresent notification: UNNotification,
                                 withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Play sound and show alert while app is in foreground
        completionHandler([.alert, .sound])
  }


  // Implement delegate method to handle display choice for in-app message
  func inAppMessage(_ ui: BrazeInAppMessageUI, displayChoiceForMessage message: Braze.InAppMessage) -> BrazeInAppMessageUI.DisplayChoice {
      // Print the entire message object to inspect its contents
      print("Received In-App Message: \(message)")
      
      
      // Check for the specific URL indicating the App Store review
      if let appStoreReviewURL = message.extras["AppStore Review"] as? String {
          print("Extras 'AppStore Review' found: \(appStoreReviewURL)")
          
          if appStoreReviewURL == "https://app.stocks.news/app-store-review" {
              print("Triggering App Store review prompt")
              SKStoreReviewController.requestReview()
              
              // Return .discard to avoid opening the URL in the browser
              return .discard
          }
      }

      // Otherwise, display the in-app message
      return .now
  }
}

 func application(
  _ application: UIApplication,
  didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
) {
  let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
  print("Successfully registered for remote notifications with device token: \(tokenString)")
  BrazePlugin.braze?.notifications.register(deviceToken: deviceToken)
  
}

  // func application(
  //   _ application: UIApplication,
  //   didReceiveRemoteNotification userInfo: [AnyHashable: Any],
  //   fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  // ) {
  //   // Handle Braze push notifications
  //   if let braze = BrazePlugin.braze, braze.notifications.handleBackgroundNotification(
  //     userInfo: userInfo,
  //     fetchCompletionHandler: completionHandler
  //   ) {
  //     return
  //   }    
  //   completionHandler(.noData)
  // }


// extension AppDelegate {

//   private func forwardURL(_ url: URL) {
//       print("Forwarding URL to Flutter: \(url.absoluteString)")
//       guard
//           let controller: FlutterViewController = window?.rootViewController as? FlutterViewController
//       else {
//           print("Failed to get FlutterViewController")
//           return
//       }
//       let deepLinkChannel = FlutterMethodChannel(
//           name: "deepLinkChannel", binaryMessenger: controller.binaryMessenger)
//       deepLinkChannel.invokeMethod("receiveDeepLink", arguments: url.absoluteString)
//   }



//   // Universal link
//   // See https://developer.apple.com/documentation/xcode/allowing-apps-and-websites-to-link-to-your-content for more information.
//   override func application(
//       _ application: UIApplication,
//       continue userActivity: NSUserActivity,
//       restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
//   ) -> Bool {
//       guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
//             let url = userActivity.webpageURL else {
//           print("Universal link handling failed: Invalid user activity or URL")
//           return false
//       }
//       print("Universal link received: \(url.absoluteString)")
//       forwardURL(url)
//       return true
//   }

// }



