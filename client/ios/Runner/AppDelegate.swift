import UIKit
import Flutter
import FirebaseCore

import google_mobile_ads

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }
    
    GeneratedPluginRegistrant.register(with: self)
    
    let listTileFactory = ListTileNativeAdFactory()
        FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
            self, factoryId: "listTile", nativeAdFactory: listTileFactory)
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  )
  {
    completionHandler(.alert)
  }
}
