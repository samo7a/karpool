import UIKit
import Flutter
import Firebase
import GoogleMaps
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
	  
    FirebaseApp.configure()
    GMSServices.provideAPIKey("AIzaSyA9V1HwU9qQEGofwLLRRn8pjd1BRWq0PtM")
    GeneratedPluginRegistrant.register(with: self)
//	  if #available(iOS 10.0, *){
//		UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
//	  }
//    UNUserNotificationCenter.current().delegate = self
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
//	override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
//    {
//        completionHandler([.alert, .badge, .sound])
//    }
	
}
