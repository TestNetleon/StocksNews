

// import UIKit
// import Flutter
// import BrazeKit
// import Firebase
// import UserNotifications
// import FirebaseMessaging
// import Combine
// import BrazeUI
// import braze_plugin

// @main
// @objc class AppDelegate: FlutterAppDelegate, MessagingDelegate, BrazeInAppMessageUIDelegate {

//   static var braze: Braze? = nil
  
//   private var methodChannel: FlutterMethodChannel?
//   private var pushNotificationCancellable: Braze.Cancellable?  

//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {

//     // Firebase Configuration
//     configureFirebase()

//     // Register Flutter plugins
//     GeneratedPluginRegistrant.register(with: self)

//     // Braze Configuration
//     configureBraze()

//     application.registerForRemoteNotifications()
//     let center = UNUserNotificationCenter.current()
//     center.setNotificationCategories(Braze.Notifications.categories)

//     center.delegate = self
//     center.requestAuthorization(options: [.badge, .sound, .alert]) { granted, error in
//       print("Notification authorization, granted: \(granted), error: \(String(describing: error))")
//     }

//     // Setup Flutter MethodChannel
//     setupMethodChannel()

//     // Subscribe to Braze notifications
//     subscribeToBrazeNotifications()

//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }

//   // MARK: - Firebase Setup
//   private func configureFirebase() {
//     FirebaseApp.configure()
//     FirebaseConfiguration.shared.setLoggerLevel(.debug)
//   }


//   private func configureBraze() {
//   // MARK: - BRAZE API KEY
//     let configuration = Braze.Configuration(
//         //LIVE
//         // apiKey: "6e2560f1-ba23-4958-a4d9-16cd577fcf65",  
//         //LOCAL
//         apiKey: "ba184694-cb2b-4e70-9e00-1e300ca9ecb0",  
//         endpoint: "sdk.iad-07.braze.com"
//     )
//     configuration.push.automation = true
//     configuration.logger.level = .info
//     // Manually enable or disable individual settings by overriding properties of `automation`. 
//     configuration.push.automation.requestAuthorizationAtLaunch = false
//     let braze = Braze(configuration: configuration)
//     AppDelegate.braze = braze
//     let inAppMessageUI = BrazeInAppMessageUI()
//     inAppMessageUI.delegate = self
//     braze.inAppMessagePresenter = inAppMessageUI
//   }

//   // MARK: - Flutter MethodChannel Setup
//   private func setupMethodChannel() {
//     methodChannel = FlutterMethodChannel(name: "brazeMethod", binaryMessenger: self.window!.rootViewController as! FlutterBinaryMessenger)

//     methodChannel?.setMethodCallHandler { [weak self] (call, result) in
//       guard let self = self else { return }

//       switch call.method {
//       case "changeUser":
//         self.handleChangeUser(call, result)
//       case "addAlias":
//         self.handleAddAlias(call, result)
//       case "logCustomEvent", "logCustomEventWithProperties":
//         self.handleLogCustomEvent(call, result)
//       case "logPurchase", "logPurchaseWithProperties":
//         self.handleLogPurchase(call, result)
//       case "setFirstName":
//         self.handleSetFirstName(call, result)
//       case "setLastName":
//         self.handleSetLastName(call, result)
//       case "setCountry":
//         self.handleSetCountry(call, result)
//       case "setEmail":
//         self.handleSetEmail(call, result)
//       case "setPhoneNumber":
//         self.handleSetPhoneNumber(call, result)
//       case "setWatchlistOrAlert":
//         self.handleSetWatchlistOrAlert(call, result)
//       case "setCustomAttribute":
//         self.handleSetCustomAttribute(call, result)
//       default:
//         result(FlutterMethodNotImplemented)
//       }
//     }
//   }

//   // MARK: - Handle Method Calls from Flutter
//   private func handleChangeUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {

//       guard let args = call.arguments as? [String: Any],
//             let userId = args["userId"] as? String else {
//           print("Invalid args: \(call.arguments ?? ""), iOS method: \(call.method)")
//           result(FlutterError(code: "INVALID_ARGUMENT", message: "Change user is required", details: nil))
//           return
//       }
//       AppDelegate.braze?.changeUser(userId)
//       result(nil)

//   }


//   private func handleAddAlias(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
//       guard let args = call.arguments as? [String: Any],
//             let aliasName = args["aliasName"] as? String,
//             let aliasLabel = args["aliasLabel"] as? String else {
//           print("Invalid args: \(call.arguments ?? ""), iOS method: \(call.method)")
//           result(FlutterError(code: "INVALID_ARGUMENT", message: "Alias name and label are required", details: nil))
//           return
//       }
//       AppDelegate.braze?.user.add(alias: aliasName, label: aliasLabel)
//       result(nil)
//   }


//   private func handleLogCustomEvent(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
//       guard let args = call.arguments as? [String: Any],
//             let eventName = args["eventName"] as? String else {
//           print("Invalid args: \(call.arguments ?? ""), iOS method: \(call.method)")
//           result(FlutterError(code: "INVALID_ARGUMENT", message: "Event name is required", details: nil))
//           return
//       }
//       let properties = args["properties"] as? [String: Any]
//       AppDelegate.braze?.logCustomEvent(name: eventName, properties: properties)
//       result(nil)
//   }


//   private func handleLogPurchase(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
//       guard let args = call.arguments as? [String: Any],
//             let productId = args["productId"] as? String,
//             let currencyCode = args["currencyCode"] as? String,
//             let price = args["price"] as? Double,
//             let quantity = args["quantity"] as? Int else {
//           print("Invalid args: \(call.arguments ?? ""), iOS method: \(call.method)")
//           result(FlutterError(code: "INVALID_ARGUMENT", message: "Purchase info is missing", details: nil))
//           return
//       }
//       let properties = args["properties"] as? [String: Any]
//       AppDelegate.braze?.logPurchase(productId: productId, currency: currencyCode, price: price, quantity: quantity, properties: properties)
//       result(nil)
//   }


//   private func handleSetFirstName(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
//       guard let args = call.arguments as? [String: Any],
//             let firstName = args["firstName"] as? String else {
//           print("Invalid args: \(call.arguments ?? ""), iOS method: \(call.method)")
//           result(FlutterError(code: "INVALID_ARGUMENT", message: "First name is required", details: nil))
//           return
//       }
//       AppDelegate.braze?.user.set(firstName: firstName)
//       result(nil)
//   }


//   private func handleSetLastName(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
//       guard let args = call.arguments as? [String: Any],
//             let lastName = args["lastName"] as? String else {
//           print("Invalid args: \(call.arguments ?? ""), iOS method: \(call.method)")
//           result(FlutterError(code: "INVALID_ARGUMENT", message: "Last name is required", details: nil))
//           return
//       }
//       AppDelegate.braze?.user.set(lastName: lastName)
//       result(nil)
//   }


//   private func handleSetCountry(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
//       guard let args = call.arguments as? [String: Any],
//             let country = args["country"] as? String else {
//           print("Invalid args: \(call.arguments ?? ""), iOS method: \(call.method)")
//           result(FlutterError(code: "INVALID_ARGUMENT", message: "Country is required", details: nil))
//           return
//       }
//       AppDelegate.braze?.user.set(country: country)
//       result(nil)
//   }


//   private func handleSetEmail(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
//       guard let args = call.arguments as? [String: Any],
//             let email = args["email"] as? String else {
//           print("Invalid args: \(call.arguments ?? ""), iOS method: \(call.method)")
//           result(FlutterError(code: "INVALID_ARGUMENT", message: "Email is required", details: nil))
//           return
//       }
//       AppDelegate.braze?.user.set(email: email)
//       result(nil)
//   }


//   private func handleSetPhoneNumber(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
//       guard let args = call.arguments as? [String: Any],
//             let phoneNumber = args["phoneNumber"] as? String else {
//           print("Invalid args: \(call.arguments ?? ""), iOS method: \(call.method)")
//           result(FlutterError(code: "INVALID_ARGUMENT", message: "Phone number is required", details: nil))
//           return
//       }
//       AppDelegate.braze?.user.set(phoneNumber: phoneNumber)
//       result(nil)
//   }

//   private func handleSetWatchlistOrAlert(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
//       guard let args = call.arguments as? [String: Any],
//             let eventName = args["eventName"] as? String,
//             let tickers = args["tickers"] as? [String] else {
//           print("Invalid args: \(call.arguments ?? ""), iOS method: \(call.method)")
//           result(FlutterError(code: "INVALID_ARGUMENT", message: "Event name or tickers missing", details: nil))
//           return
//       }
//       if eventName == "watchlists" || eventName == "alerts" {
//           AppDelegate.braze?.user.setCustomAttribute(key: eventName, array: tickers)
//           result(nil)
//       } else {
//           result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid event name", details: nil))
//       }
//   }


//   private func handleSetCustomAttribute(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
//       guard let args = call.arguments as? [String: Any],
//             let key = args["key"] as? String,
//             let value = args["value"] else {
//           print("Invalid args: \(call.arguments ?? ""), iOS method: \(call.method)")
//           result(FlutterError(code: "INVALID_ARGUMENT", message: "Custom attribute key or value missing", details: nil))
//           return
//       }

//       if let value = value as? String {
//           AppDelegate.braze?.user.setCustomAttribute(key: key, value: value)
//       } else if let value = value as? Int {
//           AppDelegate.braze?.user.setCustomAttribute(key: key, value: value)
//       } else {
//           result(FlutterError(code: "INVALID_ARGUMENT", message: "Value must be string or integer", details: nil))
//           return
//       }

//       result(nil)
//   }

//   private func subscribeToBrazeNotifications() {
//     self.pushNotificationCancellable = AppDelegate.braze?.notifications.subscribeToUpdates(payloadTypes: [.opened, .received]) { payload in
//         // Extract userInfo from the payload
//         if let userInfo = payload.userInfo as? [String: Any] {
//             print("Full userInfo dictionary: \(userInfo)")

//             // Add userInfo to the arguments being sent to Flutter
//             var arguments: [String: Any] = [
//                 "title": payload.title ?? "",
//                 "body": payload.body ?? "",
//                 "userInfo": userInfo
//             ]

//             // Logic for received notifications
//             if payload.type == .received {
//                 print("Braze processed notification (received) with title '\(payload.title)' and body '\(payload.body)'")
                
//                 self.methodChannel?.invokeMethod("onBrazeNotificationReceived", arguments: arguments)
//             }

//             // Logic for opened notifications
//             if payload.type == .opened {
//                 print("Braze processed notification (opened) with title '\(payload.title)' and body '\(payload.body)'")
                
//                 self.methodChannel?.invokeMethod("onBrazeNotificationOpened", arguments: arguments)
//             }
//         } else {
//             print("No userInfo available in the payload.")
//         }
//     }
// }

// override func application(
//   _ application: UIApplication,
//   didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
// ) {
//   let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
//   print("Successfully registered for remote notifications with device token: \(tokenString)")
//   AppDelegate.braze?.notifications.register(deviceToken: deviceToken)
// }

// override func application(
//   _ application: UIApplication,
//   didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//   fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
// ) {
//   print("Received remote notification in background/kill state with userInfo: \(userInfo)")
  
//   if let braze = AppDelegate.braze,
//      braze.notifications.handleBackgroundNotification(
//       userInfo: userInfo,
//       fetchCompletionHandler: completionHandler
//     ) {
//     print("Braze handled background notification.")
//     return
//   }
  
//   print("No data processed from notification.")
//   completionHandler(.noData)
// }

// override func userNotificationCenter(
//   _ center: UNUserNotificationCenter,
//   didReceive response: UNNotificationResponse,
//   withCompletionHandler completionHandler: @escaping () -> Void
// ) {
//   print("User interacted with notification: \(response.notification.request.content.userInfo)")
  
//   if let braze = AppDelegate.braze,
//      braze.notifications.handleUserNotification(
//       response: response,
//       withCompletionHandler: completionHandler
//     ) {
//     print("Braze handled user notification interaction.")
//     return
//   }
  
//   print("Completed handling user notification interaction.")
//   completionHandler()
// }

// override func userNotificationCenter(
//   _ center: UNUserNotificationCenter,
//   willPresent notification: UNNotification,
//   withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
// ) {
//   print("Received notification in foreground: \(notification.request.content.userInfo)")
  
//   if let braze = AppDelegate.braze {
//     braze.notifications.handleForegroundNotification(notification: notification)
//     print("Braze handled foreground notification.")
//   }

//   if #available(iOS 14.0, *) {
//     print("Presenting notification with options: [.list, .banner]")
//     completionHandler([.banner])
//   } else {
//     print("Presenting notification with options: .alert")
//     completionHandler(.alert)
//   }
// }

//   // Delegate method for handling custom scheme links.
//   override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//     forwardURL(url)
//     return true
//   }

//   // Delegate method for handling universal links.
//   override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
//     guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
//         let url = userActivity.webpageURL else {
//       return false
//     }
//     forwardURL(url)
//     return true
//   }

//   private func forwardURL(_ url: URL) {
//      print("Received deep link: \(url.absoluteString)")
//     guard let controller: FlutterViewController = window?.rootViewController as? FlutterViewController else { return }
//     let deepLinkChannel = FlutterMethodChannel(name: "deepLinkChannel", binaryMessenger: controller.binaryMessenger)
//     deepLinkChannel.invokeMethod("receiveDeepLink", arguments: url.absoluteString)
//   }

// }

import BrazeKit
import BrazeUI
import Flutter
import UIKit
import braze_plugin
import Firebase
import UserNotifications
import FirebaseMessaging

//LOCAL
// let brazeApiKey = "ba184694-cb2b-4e70-9e00-1e300ca9ecb0"

//LIVE
let brazeApiKey = "6e2560f1-ba23-4958-a4d9-16cd577fcf65"

let brazeEndpoint = "sdk.iad-07.braze.com"

@main
@objc class AppDelegate: FlutterAppDelegate {

  // These subscriptions need to be retained to be active
  var contentCardsSubscription: Braze.Cancellable?
  var pushEventsSubscription: Braze.Cancellable?
  var featureFlagsSubscription: Braze.Cancellable?

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


    // - InAppMessage UI
    // let inAppMessageUI = BrazeInAppMessageUI()
    // let inAppMessageUI = CustomInAppMessagePresenter()
    // braze.inAppMessagePresenter = inAppMessageUI

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


    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

// class CustomInAppMessagePresenter: BrazeInAppMessageUI {

//   override func present(message: Braze.InAppMessage) {
//     print("=> [In-app Message] Received message from Braze:", message)

//     BrazePlugin.processInAppMessage(message)

//     super.present(message: message)
//   }

// }


 func application(
  _ application: UIApplication,
  didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
) {
  let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
  BrazePlugin.braze?.notifications.register(deviceToken: deviceToken)
  print("Successfully registered for remote notifications with device token: \(tokenString)")
  
}

  func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {
    // Handle Braze push notifications
    if let braze = BrazePlugin.braze, braze.notifications.handleBackgroundNotification(
      userInfo: userInfo,
      fetchCompletionHandler: completionHandler
    ) {
      return
    }
    
    // If Braze doesn't handle the notification, call the default handler
    completionHandler(.noData)
  }


extension AppDelegate {

  private func forwardURL(_ url: URL) {
    guard
      let controller: FlutterViewController = window?.rootViewController as? FlutterViewController
    else { return }
    let deepLinkChannel = FlutterMethodChannel(
      name: "deepLinkChannel", binaryMessenger: controller.binaryMessenger)
    deepLinkChannel.invokeMethod("receiveDeepLink", arguments: url.absoluteString)
  }


  // Universal link
  // See https://developer.apple.com/documentation/xcode/allowing-apps-and-websites-to-link-to-your-content for more information.
  override func application(
    _ application: UIApplication, continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
  ) -> Bool {
    guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
      let url = userActivity.webpageURL
    else {
      return false
    }
    forwardURL(url)
    return true
  }
}