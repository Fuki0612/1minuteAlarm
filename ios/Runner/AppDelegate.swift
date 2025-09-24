import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // iOS 10以降の通知設定
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
      
      // 通知権限をリクエスト
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

// iOS 10以降の通知デリゲートメソッド
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
  
  // フォアグラウンドで通知を受信した時の処理
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert, .badge, .sound])
  }
  
  // 通知をタップした時の処理
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    completionHandler()
  }
}
