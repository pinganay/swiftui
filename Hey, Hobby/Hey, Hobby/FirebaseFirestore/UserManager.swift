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
    //let db = Firestore.firestore()
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
    
    
    //Updates recieved messages property for user in db
    //Called when user recieves and taps status notification from friend
    func updateRecievedMessages(forCurrentUserId currentUserId: String, recievedMessages: [String]) {
        userCollection.document(currentUserId).updateData([
            "recievedMessages": FieldValue.arrayUnion(recievedMessages)
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
