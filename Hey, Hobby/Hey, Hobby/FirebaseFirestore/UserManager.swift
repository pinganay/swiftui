//
//  UserManager.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 9/20/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class UserManager {
    static let shared = UserManager()
    let db = Firestore.firestore()
    
    private init() {}
    
    
    
    //Previous Write fuction
//    func writeUserData(user: User) async throws {
//        let userData: [String: Any] = [
//            "id": user.id,
//            "name": user.name,
//            "hobbies": user.hobbyList
//        ]
//        try await db.collection("users").document(user.id).setData(userData)
//    }
    
    func readUserData(userId: String) async throws -> DBUser {
        try await db.collection("users").document(userId).getDocument(as: DBUser.self)
    }
    
    func readAllUsers() async throws -> [DBUser] {
        var userList = [DBUser]()
        
        let querySnapshot = try await db.collection("users").getDocuments()
        
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
        try db.collection("users").document(user.id).setData(from: user)
    }
    
    func updateFriendsIdForCurrentUser(friendId: String, currentUserId: String) {
        db.collection("users").document(currentUserId).updateData([
            "friendsId": FieldValue.arrayUnion([friendId])
        ])
    }
    
    func getUsersBy(fieldName: String, fieldValue: String) async throws -> [DBUser] {
        var userList = [DBUser]()
        
        let querySnapshot = try await db.collection("users").whereField(fieldName, isEqualTo: fieldValue).getDocuments()
        
        for document in querySnapshot.documents {
            guard let user = try? document.data(as: DBUser.self) else {
                print("UserManager getUsersBy Error: Document is not correct")
                return userList
            }
            
            print("UserManager getUsersBy: \(user.firstName)")
            userList.append(user)
            print("UserManager COunt: \(userList.count)")
        }

        
//        db.collection("users").whereField(fieldName, isEqualTo: fieldValue).getDocuments { querySnapshot, error in
//            if let error = error {
//                print(error)
//                return
//            }
//
//            if let querySnapshot = querySnapshot {
//                for document in querySnapshot.documents {
//                    guard let user = try? document.data(as: DBUser.self) else {
//                        print("UserManager getUsersBy Error: Document is not correct")
//                        return
//                    }
//
//                    print("UserManager getUsersBy: \(user.firstName)")
//                    userList.append(user)
//                    print("UserManager COunt: \(userList.count)")
//                }
//
//
//            } else {
//                print("The query snapshot was empty.")
//            }
//        }
        print("UserManager final COunt: \(userList.count)")
        return userList
    }
}
