//
//  UserProfileViewModel.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 10/4/23.
//

import Foundation
import CloudKit

@MainActor class UserProfileViewModel: ObservableObject {
    
    @Published var userMessage = ""
    @Published var userList = [DBUser]()
    @Published var friendsList = [DBUser]()
    @Published var selectedFriendId = "" {
        didSet {
            Task {
                let user = try await readUserData(userId: selectedFriendId)
                let isDuplicate = searchFor(user: user, in: friendsList)
                if isDuplicate {
                    print("UserProfileViewModel Error: User already in friends list")
                } else {
                    friendsList.append(user)
                    let currentUser = await readCurrentUser()
                    updateFriendsIdForCurrentUserInDB(currentUserId: currentUser.id)
                }
            }
        }
    }
    
    init() {
        getiCloudStatus()
        requestiCloudPermission()
    }
    
    enum CloudKitError: String, LocalizedError {
        case iCloudAccountNotDetermined
        case iCloudAccountRestricted
        case iCloudAccountNotFound
        case iCloudAccountUnknown
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
    
    func addMessage(message: String) {
        let newNotification = CKRecord(recordType: "Notifications")
        newNotification["Message"] = message
        saveMessage(record: newNotification)
    }
    
    private func saveMessage(record: CKRecord) {
        CKContainer.default().publicCloudDatabase.save(record) { record, error in
            print("Record: \(String(describing: record))")
            print("Error: \(String(describing: error))")
        }
    }
    
    func updateFriendsIdForCurrentUserInDB(currentUserId: String) {
        UserManager.shared.updateFriendsIdForCurrentUser(friendId: selectedFriendId, currentUserId: currentUserId)
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
