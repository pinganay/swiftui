//
//  AppDelegate.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 1/2/24.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    
    @Published var title: String?
    @Published var body: String?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Check if launched from notification
        // app wasn’t running and the user launches it by tapping the push notification
        print("app wasn’t running and the user launches it by tapping the push notification")
        let notificationOption = launchOptions?[.remoteNotification]
        
        if
            let notification = notificationOption as? [String: AnyObject],
            let aps = notification["aps"] as? [String: AnyObject] {
            
            let alert = aps["alert"] as? [String: String]
            title = alert?["title"]
            body = alert?["body"]
            print(title ?? "nil")
            print(body ?? "nil")
        }
        return true
    }
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler:
        @escaping (UIBackgroundFetchResult) -> Void
    ) {
        
        print("app was running either in the foreground or the background")
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler(.failed)
            return
        }
        let alert = aps["alert"] as? [String: String]
        title = alert?["title"]
        body = alert?["body"]
        print(title ?? "nil")
        print(body ?? "nil")
    }

}
