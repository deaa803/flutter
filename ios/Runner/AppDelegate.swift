import Flutter
import UIKit
import flutter_local_notifications 

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    //ios
    FlutterLocalNotificationPlugin.setPluginRegistrantCallback{ (registry) in GeneratedPluginRegistrant.register(with:self)}

    if #available(ios 10.0,*){
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
 