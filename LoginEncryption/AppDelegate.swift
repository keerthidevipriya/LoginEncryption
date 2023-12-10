//
//  AppDelegate.swift
//  LoginEncryption
//
//  Created by Keerthi Devipriya(kdp) on 08/12/23.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func notifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.sound, .badge, .alert]) { s, err in
            if s {
                print("Authorized sucessfully")
            } else {
                print("Authorization failed")
            }
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        notifications()
        // when app in background use the following command
        /*
         xcrun simctl push DDCD1E99-DE6B-49BC-B023-C2601166531E com.encryption.login.LoginEncryption apn.apns
         Tumblr Post: https://www.tumblr.com/visioncodekdp/736300827342520320/sending-the-push-notification-using-apns?source=share
         */
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Remote notification received (tapped, or while app in foreground)")
    }
}

/*
 apns json code
 {
     "aps" : {
         "alert" : {
             "title" : "Hi",
             "subtitle" : "I am your notification",
             "body" : "I would like to send the encrypted string",
         },
         "category" : "Identifier Buttons"
     },
     "id": "12345"
 }
 */
