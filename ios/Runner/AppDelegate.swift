import UIKit
import Flutter
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
        if granted {
          print("iOS通知権限が許可されました")
        } else {
          print("iOS通知権限が拒否されました: \(error?.localizedDescription ?? "不明なエラー")")
        }
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}