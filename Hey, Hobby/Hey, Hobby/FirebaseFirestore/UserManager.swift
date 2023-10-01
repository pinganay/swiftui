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
    
//    func readUserData() async throws {
//        db.collection("users").getDocuments { querySnapshot, error in
//            if let error = error {
//                print("There was an error reading the data from 'users' collection: \(error.localizedDescription)")
//            } else {
//                guard let querySnapshot = querySnapshot else {
//                    print("The querySnapshot has no data")
//                    return
//                }
//
//                let documents = querySnapshot.documents
//
//                for document in documents {
//                    print("\(document.documentID) -> \(document.data())")
//                }
//            }
//        }
//    }
    
//    func readUserData(id: String) async throws {
//        let idRef = db.collection("users")
//        let query = idRef.whereField("id", isEqualTo: id)
//        
//        query.getDocuments { querySnapshot, error in
//            if let error = error {
//                print("There was an error reading the data from 'users' collection: \(error.localizedDescription)" )
//            } else {
//                guard let querySnapshot = querySnapshot else {
//                    print("The querySnapshot has no data")
//                    return
//                }
//                
//                let documents = querySnapshot.documents
//                
//                if documents.count == 1 {
//                    print(documents[0].data())
//                } else {
//                    print("There was duplicate data for the user with id: \(id)")
//                    return
//                }
//            }
//        }
//    }
    
    func writeUserData(user: DBUser) async throws {
        try db.collection("users").document(user.id).setData(from: user)
    }
}
