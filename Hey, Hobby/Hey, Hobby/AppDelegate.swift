//
//  AppDelegate.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 1/2/24.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, ObservableObject {
    
    @Published var title: String?
    @Published var body: String?
    @Published var date: String?
    @Published var time: String?
    @Published var debugString: String?
    @Published var recievedMessages = [String]()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Check if launched from notification
        // app was running in foreground or not running at all, and the user launches it by tapping the push notification
        print("app wasn’t running and the user launches it by tapping the push notification")
        let notificationOption = launchOptions?[.remoteNotification]
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        return true
    }
    
    /*
     This function is called when notification is received and user taps on it
     */
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Inside userNotificationCenter() didReceive")
        let userInfo = response.notification.request.content.userInfo
        
        let application = UIApplication.shared
        
        if(application.applicationState == .active){
            //Prints the message when user tapped the notification bar when the app is in foreground
            print("user tapped the notification bar when the app is in foreground")
            debugString = "userNotificationCenter() didReceive ; .active"
            print(userInfo)
            //Get the title of userInfo
            
            proccesUserInfoDidRecieve(userInfo: userInfo, response: response)
        }
        
        //This will run when the app is killed
        if(application.applicationState == .background){
            print("Received notification when the app is in background")
            debugString = "userNotificationCenter() didReceive ; .background"
            print(userInfo)
            //Get the title of userInfo
            
            proccesUserInfoDidRecieve(userInfo: userInfo, response: response)
        }
        
        if (application.applicationState == .inactive) {
            print("user tapped the notification bar when the app is in inactive state")
            debugString = "userNotificationCenter() didReceive ; .inactive"
            print(userInfo)
//            guard let aps = userInfo["aps"] as? [String: AnyObject] else {
//                completionHandler()
//                return
//            }
//
//            date = response.notification.date.formatted(date: .numeric, time: .omitted)
//            time = response.notification.date.formatted(date: .omitted, time: .shortened)
//            print("\(response.notification.date.formatted(date: .omitted, time: .shortened))")
//            print("\(response.notification.date.formatted(date: .numeric, time: .omitted))")
//
//            let alert = aps["alert"] as? [String: String]
//            title = alert?["title"]
//            body = alert?["body"]
//            print(title ?? "nil")
//            print(body ?? "nil")
            
            proccesUserInfoDidRecieve(userInfo: userInfo, response: response)
        }
        
        completionHandler()
    }
    
    /*
     This function is called when app is open and a notification is received
     */
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent: UNNotification,
                                withCompletionHandler: @escaping (UNNotificationPresentationOptions)->()) {
        withCompletionHandler([.alert, .sound, .badge])

        print("Inside userNotificationCenter() willPresent")
        let userInfo = willPresent.request.content.userInfo

        let application = UIApplication.shared

//        if (application.applicationState == .active) {
//            //Prints the message when user tapped the notification bar when the app is in foreground
//            print("user tapped the notification bar when the app is in foreground")
//            debugString = "userNotificationCenter() willPresent ; .active"
//            print(userInfo)
//
////            guard let aps = userInfo["aps"] as? [String: AnyObject] else {
////                return
////            }
////            let alert = aps["alert"] as? [String: String]
////            title = alert?["title"]
////            body = alert?["body"]
////            print(title ?? "nil")
////            print(body ?? "nil")
//
//        }
//
//        if (application.applicationState == .inactive) {
//            print("user tapped the notification bar when the app is in inactive state")
//            debugString = "userNotificationCenter() willPresent ; .inactive"
//
////            guard let aps = userInfo["aps"] as? [String: AnyObject] else {
////                return
////            }
////            let alert = aps["alert"] as? [String: String]
////            title = alert?["title"]
////            body = alert?["body"]
////            print(title ?? "nil")
////            print(body ?? "nil")
//
//        }
//
//        if (application.applicationState == .background) {
//            print("notification received when the app is in background")
//            debugString = "userNotificationCenter() willPresent ; .background"
//            print(userInfo)
//
////            guard let aps = userInfo["aps"] as? [String: AnyObject] else {
////                return
////            }
////            let alert = aps["alert"] as? [String: String]
////            title = alert?["title"]
////            body = alert?["body"]
////            print(title ?? "nil")
////            print(body ?? "nil")
//
//        }

        withCompletionHandler([.alert, .sound, .badge])

    }
    
//    func application(
//        _ application: UIApplication,
//        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//        fetchCompletionHandler completionHandler:
//        @escaping (UIBackgroundFetchResult) -> Void
//    ) {
//
//        print("app was running either in the foreground or the background")
//
//        let center = UNUserNotificationCenter.current()
//        center.delegate = self
//
//        print(userInfo)
//        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
//            return
//        }
//        let alert = aps["alert"] as? [String: String]
//        title = alert?["title"]
//        body = alert?["body"]
//        print(title ?? "nil")
//        print(body ?? "nil")
//    }
    
    func proccesUserInfoDidRecieve(userInfo: [AnyHashable : Any], response: UNNotificationResponse) {
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            return
        }
        
        date = response.notification.date.formatted(date: .numeric, time: .omitted)
        time = response.notification.date.formatted(date: .omitted, time: .shortened)
        
        let alert = aps["alert"] as? [String: String]
        title = alert?["title"]
        body = alert?["body"]
        print(title ?? "nil")
        print(body ?? "nil")
        
        let fullMessage = "\(date ?? "") : \(time ?? "") : \(body ?? "")"
        recievedMessages.append(fullMessage)
        
        //This is explicitly used since we can't use an environment object in this class
        guard let authenticatedUser = try? AuthManager.shared.getAuthenticatedUser() else { return }
        
        UserManager.shared.updateRecievedMessages(forCurrentUserId: authenticatedUser.uid, recievedMessages: recievedMessages)
    }
}
