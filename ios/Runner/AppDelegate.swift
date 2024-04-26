import UIKit
import Flutter
// import BitlySDK // Import BitlySDK

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    //  Bitly.initialize("Ao1seSO8XNS", supportedDomains: ["stocks.news", "app.stocks.news"], supportedSchemes: ["algo.moe"]) { 
    //      response, error in
    //         // Handle initialization response and error
    //         // response provides a BitlyResponse object which contains the full URL information
    //         // response includes a status code
    //         // error provides any errors in retrieving information about the URL
    //         // Your custom logic goes here...
    //         if let error = error {
    //     // Handle error
    //     print("** *** ** Bitly SDK initialization error: \(error)")
    // } else {
    //     // Handle successful initialization
    //     print("** *** **  Bitly SDK initialized successfully")
        
    //     if let response = response {
    //         // Print detailed response information
    //         print("** *** ** Bitly SDK response: \(response)")
            
    //         // Access specific information if needed
    //         if let statusCode = response.statusCode {
    //             print("** *** **  Bitly SDK status code: \(statusCode)")
    //         }
            
    //         // Your custom logic goes here...
    //     }
    // }
    //     }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Other methods in your AppDelegate...
  
  // Handle incoming links
//   override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//      print("*** *** *** *** ** *** ** ** Opened URL: \(url)")
//       return Bitly.handleOpen(url)
//   }
  
//  // Handle Universal Links
//  override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
//      print("*** *** *** *** ** *** ** **  Universal Link URL: ")
//      return Bitly.handle(userActivity)
//  }
}
