import UIKit
import Flutter
import GoogleMaps
//import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyCwsodVCubEqLEyKBsukvPvEfp7EVP4WWI")
    GeneratedPluginRegistrant.register(with: self)
    //FirebaseApp.configure()
    //if #available(iOS 10.0, *) {
     // UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    //}
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    // This method will be called when app received push notifications in foreground
    //@available(iOS 10.0, *)
    //override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    //{
     //   completionHandler([.alert, .badge, .sound])
    //}
}
