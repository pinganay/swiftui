//
//  UserProfileViewModel.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 10/4/23.
//

import Foundation
import CloudKit
import UserNotifications
import UIKit
import SwiftUI

@MainActor class UserProfileViewModel: ObservableObject {
    
    @Published var messageList = [String]()
    @Published var userMessage = ""
    @Published var userList = [DBUser]()
    @Published var friendsList = [DBUser]()
    @Published var loadFriendsListFromDB = true
    @Published var isUserSubscribed = false
    @Published var isFriendAdded = true
    @Published var selectedFriendId = "" {
        didSet {
            if isFriendAdded {
                addFriendsIdForCurrentUserInDB(currentUserId: selectedFriendId)
            } else {
                removeFriendsIdForCurrentUserInDB(currentUserId: selectedFriendId)
            }
        }
    }
    @Published var hobbyList = ["Soccer", "Drawing", "Cooking", "aaSoccerbbb", "Fencing", "aaSocbbb"]
    @Published var filteredHobbies: [String] = []
    @Published var disableSendButton = true
    var buttonColor: Color {
        return disableSendButton ? .gray : .accentColor
    }
    
    init() {
        getiCloudStatus()
        requestiCloudPermission()
        fetchMessages()
    }
    
    enum CloudKitError: String, LocalizedError {
        case iCloudAccountNotDetermined
        case iCloudAccountRestricted
        case iCloudAccountNotFound
        case iCloudAccountUnknown
    }
    
    func ValidateUserString(_ userString: String) {
        //if hobbyList.contains(userString.localizedLowercase) {
        if hobbyList.contains(where: {$0.caseInsensitiveCompare(userString) == .orderedSame}) {
            disableSendButton = false
        } else {
            disableSendButton = true
        }
        print(disableSendButton)
    }
    
    func requestNotificationPermissions() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                print("requestNotificationPermissions Error: \(error.localizedDescription)")
            } else if success {
                print("requestNotificationPermissions: Notification Permissions Success")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("requestNotificationPermissions: Notification Permissions Failure")
            }
        }
    }
    
    func subscibeToNotifications() {
        for friend in friendsList {
            print("friend.id : \(friend.id)")
            let predicate = NSPredicate(format: "UserId = %@", friend.id)
            
            let subscription = CKQuerySubscription(recordType: "Notifications", predicate: predicate, subscriptionID: "\(friend.id)", options: .firesOnRecordCreation)
            let notification = CKSubscription.NotificationInfo()
            /*
             Reads data from CloudKit then shows body and title on notification
             The value of the "Message" field from CloudKit gets passed as the body of the notification
             The value of the "UserName" field from CloudKit gets passed as the title of the notification
             */
            
            
            notification.titleLocalizationKey = "Hey Hobby!\nFrom: %1$@"
            notification.titleLocalizationArgs = ["UserName"]

            notification.alertLocalizationKey = "%1$@"
            notification.alertLocalizationArgs = ["Message"]

            notification.desiredKeys = ["Message", "UserName"]
            notification.shouldSendContentAvailable = true

//            notification.shouldBadge = true
            notification.soundName = "default"
            
            
            subscription.notificationInfo = notification
            
            CKContainer.default().publicCloudDatabase.save(subscription) { subcription, error in
                if let error = error {
                    print("subscibeToNotifications Error: \(error.localizedDescription)")
                } else {
                    print("subscibeToNotifications: Successfully subscribed to Notifications: \(subcription?.subscriptionID)")
                }
            }
        }
    }
    
    func unsubscibeToNotifications() {
//        CKContainer.default().publicCloudDatabase.delete(withSubscriptionID: "notification_added_to_database") { id, error in
//            if let error = error {
//                print("unsubscibeToNotifications Error: \(error.localizedDescription)")
//            } else {
//                print("unsubscibeToNotifications: Successfully unsubscribed to Notifications")
//            }
//        }
        CKContainer.default().publicCloudDatabase.fetchAllSubscriptions { [unowned self] subscriptions, error in
            if error == nil {
                if let subscriptions = subscriptions {
                    for subscription in subscriptions {
                        CKContainer.default().publicCloudDatabase.delete(withSubscriptionID: subscription.subscriptionID) { str, error in
                            if error != nil {
                                // do your error handling here!
                                print(error!.localizedDescription)
                            }
                            
                            print("Unsubscribed \(subscription.subscriptionID) succesfully")
                        }
                    }
                    
                    // more code to come!
                }
            } else {
                // do your error handling here!
                print(error!.localizedDescription)
            }
        }
    }
    
    func requestiCloudPermission() {
        CKContainer.default().requestApplicationPermission([.userDiscoverability]) { status, error in
            DispatchQueue.main.async {
                if status == .granted {
                    print("requestiCloudPermission Status: \(status)")
                    print("requestiCloudPermission Error: \(String(describing: error))")
                }
            }
        }
    }
    
    func getiCloudStatus() {
        var error = ""
        
        CKContainer.default().accountStatus { status, returnedError in
            DispatchQueue.main.async {
                switch status {
                case .available:
                    print("iCloud Account found")
                case .couldNotDetermine:
                    error = CloudKitError.iCloudAccountNotDetermined.rawValue
                    print(error)
                case .restricted:
                    error = CloudKitError.iCloudAccountRestricted.rawValue
                    print(error)
                case .noAccount:
                    error = CloudKitError.iCloudAccountNotFound.rawValue
                    print(error)
                default:
                    error = CloudKitError.iCloudAccountUnknown.rawValue
                    print(error)
                }
            }
        }
    }
    
    func addMessage(message: String, userId: String, currentUserName: String) {
        guard !userMessage.isEmpty else { return }
        
        let newNotification = CKRecord(recordType: "Notifications")
        newNotification["Message"] = message
        newNotification["UserId"] = userId
        newNotification["UserName"] = currentUserName
        saveMessage(record: newNotification)
    }
    
    private func saveMessage(record: CKRecord) {
        CKContainer.default().publicCloudDatabase.save(record) { record, error in
            print("Record: \(String(describing: record))")
            print("Error: \(String(describing: error))")
        }
        
        userMessage = ""
    }
    
    func fetchMessages() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Notifications", predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        
        var returnedMessages = [String]()
        
        queryOperation.recordMatchedBlock = { (recordID, result) in
            switch result {
            case .success(let record):
                guard let message = record["Message"] as? String else { return }
                returnedMessages.append(message)
            case .failure(let error):
                print("fetchMessages Error: \(error)")
            }
        }
        
        queryOperation.queryResultBlock = { [weak self] result in
            print("fetchMessages Result: \(result)")
            DispatchQueue.main.async {
                self?.messageList = returnedMessages
            }
        }
        
        addOperation(operation: queryOperation)
    }
    
    func addOperation(operation: CKDatabaseOperation) {
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    func updateMessageList(message: String) {
        self.messageList.append(message)
    }
    
    func removeFriendsIdForCurrentUserInDB(currentUserId: String) {
        UserManager.shared.removeFriendsIdForCurrentUser(friendId: selectedFriendId, currentUserId: currentUserId)
    }
    
    func addFriendsIdForCurrentUserInDB(currentUserId: String) {
        UserManager.shared.addFriendsIdForCurrentUser(friendId: selectedFriendId, currentUserId: currentUserId)
    }
    
    func removeFriendsIdForCurrentUserInDB(currentUserId: String, friendId: String) {
        UserManager.shared.removeFriendsIdForCurrentUser(friendId: friendId, currentUserId: currentUserId)
    }
    
    func addFriendsIdForCurrentUserInDB(currentUserId: String, friendId: String) {
        UserManager.shared.addFriendsIdForCurrentUser(friendId: friendId, currentUserId: currentUserId)
    }
    
    func removeFriendList() {
        Task {
            let user = try await readUserData(userId: selectedFriendId)
            let isDuplicate = searchFor(user: user, in: friendsList)
            if isDuplicate {
                print("UserProfileViewModel Error: User already in friends list")
            } else {
                friendsList.append(user)
                let currentUser = await readCurrentUser()
                removeFriendsIdForCurrentUserInDB(currentUserId: currentUser.id)
            }
        }
    }
    
    func addFriendList() {
        Task {
            let user = try await readUserData(userId: selectedFriendId)
            let isDuplicate = searchFor(user: user, in: friendsList)
            if isDuplicate {
                print("UserProfileViewModel Error: User already in friends list")
            } else {
                friendsList.append(user)
                let currentUser = await readCurrentUser()
                addFriendsIdForCurrentUserInDB(currentUserId: currentUser.id)
            }
        }
    }
    
    func readCurrentUser() async -> DBUser {
        do {
            let authenticatedUser = try AuthManager.shared.getAuthenticatedUser()
            let currentUser = try await UserManager.shared.readUserData(userId: authenticatedUser.uid)
            return currentUser
        } catch {
            print("UserProfileViewModel Error: \(error.localizedDescription)")
            return DBUser.sampleUser
        }
    }
    
    func searchFor(user: DBUser, in userList: [DBUser]) -> Bool {
        if userList.contains(user) {
            return true
        }
        
        return false
    }
    
    func getLoggedInUser() async -> DBUser {
        let readUserDataTask = Task { () -> DBUser in
            do {
                let authenticatedUser = try AuthManager.shared.getAuthenticatedUser()
                let user = try await readUserData(userId: authenticatedUser.uid)
                
                return user
            }
        }
        
        let readUserDataTaskResult = await readUserDataTask.result
        
        do {
            let dbUser = try readUserDataTaskResult.get()
            return dbUser
        } catch {
            print("UserProfileViewModel Error: \(error.localizedDescription)")
            return DBUser.sampleUser
        }
    }
    
    func signOut()  {
        do {
            try AuthManager.shared.signOut()
        } catch {
            print(error)
        }
    }
    
    func loadCurrentUserFriendsList(userIdList: [String]) {
        for id in userIdList {
            Task {
                do {
                    let user = try await readUserData(userId: id)
                    friendsList.append(user)
                } catch {
                    print("UserProfileViewModel Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func readUserData(userId: String) async throws -> DBUser {
        
        let readUserDataTask =  Task { () -> DBUser in
            let user = try await UserManager.shared.readUserData(userId: userId)
            return user
        }
        
        let readUserDataTaskResult = await readUserDataTask.result
        
        do {
            let dbUser = try readUserDataTaskResult.get()
            return dbUser
        } catch {
            print("UserProfileView Error: \(error.localizedDescription)")
            return DBUser.sampleUser
        }
    }
    
    /*
     getting all users from DB
     filtering out current user from userList
     */
    
    func getAllUsersWithoutCurrentUser() {
        Task {
            let loggedInUser = await getLoggedInUser()
            
            do {
                userList = try await UserManager.shared.readAllUsers()
                userList = userList.filter { $0 != loggedInUser }
            } catch {
                print("There was an error: \(error.localizedDescription)")
            }
        }
    }
}
