//
//  AppDelegate.swift
//  67thChofufesApp
//
//  Created by 松田尚也 on 2017/09/03.
//  Copyright © 2017年 67thChofufes. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var push = true
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        /*
        UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
        Messaging.messaging().delegate = self as MessagingDelegate
        
        application.registerForRemoteNotifications()
 
        
       */
        
        // google maps
        GMSServices.provideAPIKey("AIzaSyCT3_ATxvBFIfdF9P0pbnCtaThKBneSxC4")
        //GMSPlacesClient.provideAPIKey("AIzaSyCw2rX_JJ4HgBliGqLxf2PV6wnex9JbWcc")
        
        requestNotificationAuthorization(application: application)
        
        application.registerForRemoteNotifications()
        
        if let userInfo = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] {
            NSLog("[RemoteNotification] applicationState: \(applicationStateString) didFinishLaunchingWithOptions for iOS9: \(userInfo)")
            //TODO: Handle background notification
        }
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler handlerBlock:
        (UNNotificationPresentationOptions) -> Void) {
        // Roll banner and sound alert
        handlerBlock([.alert])
    }
    
    //AppDelegateに通知トークンをサーバーに送る処理を追加します。
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    var applicationStateString: String {
        if UIApplication.shared.applicationState == .active {
            return "active"
        } else if UIApplication.shared.applicationState == .background {
            return "background"
        }else {
            return "inactive"
        }
    }
    
    func requestNotificationAuthorization(application: UIApplication) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
    }
    
    // アプリがバックグラウンドで通知を受け、ユーザが通知をタップしてアプリをフォアグランドにした時に呼ばれる
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        debugPrint("You tapped the message.")
        
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        // Print full message.
        print("%@", userInfo)
        
        completionHandler()
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String)
    {
        
    }
 
    // Remote Notification のエラーを受け取る
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        if push{
            push = false
            //通知が既存かどうか
            let center = UNUserNotificationCenter.current()
            
            center.getDeliveredNotifications { notifications in
                let identifiers = notifications
                    .filter { $0.request.identifier == "ChofufesRecommend"}
                    .map { $0.request.identifier }
                print(identifiers)
                center.removeDeliveredNotifications(withIdentifiers: identifiers)
            }
            
            // content
            let content = UNMutableNotificationContent()
            content.title = "通知機能のおすすめ"
            content.body = "調布祭アプリをバックグラウンド状態にしておくことで通知を受け取ることが出来ます。主には最新のお知らせを通知していきます！"
            content.sound = UNNotificationSound.default()
            
            // trigger
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(3.0),
                                                            repeats: false)
            
            // request includes content & trigger
            let request = UNNotificationRequest(identifier: "ChofufesRecommend",
                content: content,
                trigger: trigger)
            
            // schedule notification by adding request to notification center
            center.add(request) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
        
    }

}



