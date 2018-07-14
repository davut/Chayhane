//
//  AppDelegate.swift
//  Chayhane
//
//  Created by djepbarov on 9.07.2018.
//  Copyright © 2018 chayhane. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import IQKeyboardManager
import NotificationCenter
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    var db: Firestore?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        IQKeyboardManager.shared().isEnabled = true
        
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = false
        
        // Any additional options
        // ...
        
        let db = Firestore.firestore()
        db.settings = settings
        NotificationCenter.default.addObserver(self, selector: #selector(tokenRefreshNotification), name: NSNotification.Name(rawValue: "tokenAvailable"), object: nil)

        application.registerForRemoteNotifications()
    
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        
        if let token = InstanceID.instanceID().token(){
            print("Firebase Token : \(token)")
        }else{
            print("Firebase Token nil")
        }
        return true
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tokenAvailable"), object: nil)
        
        print("Firebase Registration Token \(fcmToken)")
        
    }

    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Notification did receive")
        
    }


    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        let token = Messaging.messaging().fcmToken
        Messaging.messaging().apnsToken = deviceToken
        #if PROD_BUILD
        Messaging.messaging().setAPNSToken(deviceToken, type: .prod)
        #else
        Messaging.messaging().setAPNSToken(deviceToken, type: .sandbox)
        #endif
        print("FCM token: \(token ?? "")")
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
    }
    

    func printFCMToken() {
        if let token = InstanceID.instanceID().token() {
            print("Your FCM token is \(token)")
        } else {
            print("You don't yet have an FCM token.")
        }
    }

    @objc func tokenRefreshNotification(_ notification: NSNotification?) {
    if let updatedToken = InstanceID.instanceID().token() {
        db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        db?.collection("users").document("\(uid ?? "no uid")").updateData(["token": updatedToken])
        printFCMToken()
        
        // Do other work here like sending the FCM token to your server
    } else {
        print("We don't have an FCM token yet")
    }
}




    
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void) {
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Notification Will Present")
        completionHandler([.alert, .badge, .sound])
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

