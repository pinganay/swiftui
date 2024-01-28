//
//  UserManager.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 9/20/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

final class UserManager {
    static let shared = UserManager()
    //let userCollection = Firestore.firestore().collection("users")
    let userCollection = Firestore.firestore().collection("testusers")
    
    private init() {}

    func deleteUserDocument(documentId: String) async {
        do {
            try await userCollection.document(documentId).delete()
        } catch {
            print("deleteUserDocument(): There was an error while deleting the document: \(error.localizedDescription)")
        }
        
//        userCollection.document(documentId).delete { error in
//            if let error = error {
//                print("deleteUserDocument(): There was an error while deleting the document: \(error.localizedDescription)")
//            }
//        }
        
        print("deleteUserDocument(): Succesfully deleted the document")
    }
    
    func readUserData(userId: String) async throws -> DBUser {
        try await userCollection.document(userId).getDocument(as: DBUser.self)
    }
    
    func fetchDBUsers(userIDList: [String]) async -> [DBUser] {
        var userList = [DBUser]()
        
        do {
            for userID in userIDList {
                let user = try await readUserData(userId: userID)
                userList.append(user)
            }
        } catch {
            print("fetchDBUsers() error: \(error.localizedDescription)")
        }
        
        return userList
    }
    
    func readAllUsers() async throws -> [DBUser] {
        var userList = [DBUser]()
        
        let querySnapshot = try await userCollection.getDocuments()
        
        for document in querySnapshot.documents {
            guard let user = try? document.data(as: DBUser.self) else {
                print("UserManger: Document has nil value")
                return userList
            }
            
            print("UserManager: \(user.firstName)")
            userList.append(user)
        }
        
        return userList
    }
    
    func writeUserData(user: DBUser) async throws {
        try userCollection.document(user.id).setData(from: user)
    }
    
    func removeFriendsIdForCurrentUser(friendId: String, currentUserId: String) {
        userCollection.document(currentUserId).updateData([
            "friendsId": FieldValue.arrayRemove([friendId])
        ])
    }
    
    func addFriendsIdForCurrentUser(friendId: String, currentUserId: String) {
        userCollection.document(currentUserId).updateData([
            "friendsId": FieldValue.arrayUnion([friendId])
        ])
    }
    
    func addFriendsId(forUserId userId: String, friendId: String) {
        userCollection.document(userId).updateData([
            "friendsId": FieldValue.arrayUnion([friendId])
        ])
    }
    
    //This function removes the friend request id from the current user's friendRequestsRecieved list
    func deleteUserIDFromFriendRequestsRecieved(userId: String) {
        do {
            let currentUserId = try AuthManager.shared.getAuthenticatedUser().uid
            userCollection.document(currentUserId).updateData([
                "friendRequestsRecieved": FieldValue.arrayRemove([userId])
            ])
        } catch {
            print("deleteRequestsForFriendApproval() error: \(error.localizedDescription)")
        }
    }
    
    //This function removes the friend request id that was sent from the current user's friendRequestsSent list
    func deleteUserIDFromFriendRequestsSent(userId: String) {
        do {
            let currentUserId = try AuthManager.shared.getAuthenticatedUser().uid
            userCollection.document(userId).updateData([
                "friendRequestsSent": FieldValue.arrayRemove([currentUserId])
            ])
        } catch {
            print("deleteRequestsForFriendApproval() error: \(error.localizedDescription)")
        }
    }
    
    //This function updates the friendRequestsRecieved for the friend and updates the friendRequestsSent for the current user
    //We only need to pass in the friend's id to the function
    //The current user id is accesible in this class, so we don't have to pass it into this function
    func updateRequestsForFriendApproval(friendId: String) {
//        userCollection.document(currentUserId).updateData([
//            "friendsId": FieldValue.arrayUnion([friendId])
//        ])
        var currentUserId = ""
        
        do {
            let currentUser = try AuthManager.shared.getAuthenticatedUser()
            currentUserId = currentUser.uid
        } catch {
            print("updateRequestsForFriendApproval() error: \(error.localizedDescription)")
        }
        
        //This will update the friendRequestsSent array for the current user
        userCollection.document(currentUserId).updateData([
            "friendRequestsSent": FieldValue.arrayUnion([friendId])
        ])
        
        //This will update the friendRequestsRecieved array for the friend
        userCollection.document(friendId).updateData([
            "friendRequestsRecieved": FieldValue.arrayUnion([currentUserId])
        ])
    }
    
    //Updates recieved messages property for user in db
    //Called when user recieves and taps status notification from friend
    func addRecievedMessages(forCurrentUserId currentUserId: String, recievedMessages: [String]) {
        userCollection.document(currentUserId).updateData([
            "recievedMessages": FieldValue.arrayUnion(recievedMessages)
        ])
    }
    
    func deleteRecievedMessages(forCurrentUserId currentUserId: String, recievedMessages: [String]) {
        print(currentUserId)
        print(recievedMessages)
        userCollection.document(currentUserId).updateData([
            "recievedMessages": FieldValue.arrayRemove(recievedMessages)
        ])
    }
    
    func addStatusHistory(forCurrentUserId currentUserId: String, statusHistory: [String]) {
        userCollection.document(currentUserId).updateData([
            "statusHistory": FieldValue.arrayUnion(statusHistory)
        ])
    }
    
    func deleteStatusHistory(forCurrentUserId currentUserId: String, statusHistory: [String]) {
        userCollection.document(currentUserId).updateData([
            "statusHistory": FieldValue.arrayRemove(statusHistory)
        ])
    }
    
    func getUsersBy(fNameField: String, fNameValue: String, lNameField: String, lNameValue: String, phoneNumberField: String, phoneNumberValue: String) async throws -> [DBUser] {
        var userList = [DBUser]()
        
        let querySnapshot = try await userCollection
            .whereField(fNameField, isEqualTo: fNameValue)
            .whereField(lNameField, isEqualTo: lNameValue)
            .whereField(phoneNumberField, isEqualTo: phoneNumberValue)
            .getDocuments()
        
        for document in querySnapshot.documents {
            guard let user = try? document.data(as: DBUser.self) else {
                print("UserManager getUsersBy Error: Document is not correct")
                return userList
            }
            
            print("UserManager getUsersBy: \(user.firstName)")
            userList.append(user)
            print("UserManager COunt: \(userList.count)")
        }

        print("UserManager final COunt: \(userList.count)")
        return userList
    }
    
    func getUsersByEmailAndPhoneNumber(emailValue: String, phoneNumberValue: String) async throws -> [DBUser] {
        var userList = [DBUser]()
        
        let querySnapshot = try await userCollection.whereFilter(
            Filter.orFilter([
            Filter.whereField("emailAddress", isEqualTo: emailValue.lowercased()),
            Filter.whereField("phoneNumber", isEqualTo: phoneNumberValue),
            Filter.andFilter([
                Filter.whereField("emailAddress", isEqualTo: emailValue),
                Filter.whereField("phoneNumber", isEqualTo: phoneNumberValue)
            ])
        ])).getDocuments()
        
        
        
//        let querySnapshot2 = try await userCollection.whereFilter(
//            Filter.orFilter([
//                Filter.andFilter([
//                    Filter.whereField("emailAddress", isEqualTo: emailValue),
//                    Filter.whereField("phoneNumber", isEqualTo: phoneNumberValue)
//                ])
//            ]
//            )
//            ).getDocuments()
//        
//        let querySnapshot3 = try await userCollection.whereFilter(
//            Filter.orFilter([
//                Filter.whereField("emailAddress", isEqualTo: emailValue.lowercased()),
//                Filter.whereField("phoneNumber", isEqualTo: phoneNumberValue)
//            ]
//            )
//            ).getDocuments()
//        
//        
//        let querySnapshot4: QuerySnapshot
//        if !emailValue.isEmpty && !phoneNumberValue.isEmpty {
//            querySnapshot4 = querySnapshot2
//        } else {
//            querySnapshot4 = querySnapshot3
//        }
        
        
        for document in querySnapshot.documents {
            let user = try document.data(as: DBUser.self)
            userList.append(user)
        }
        
        return userList
    }
}
