//
//  AuthManager.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 9/23/23.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let isEmailVerified: Bool
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.isEmailVerified = user.isEmailVerified
    }
    
}

final class AuthManager {
    static let shared = AuthManager()
    private init() {}
    
    // This fuction deletes user from authentication db
    func deleteCurrentUser() {
        guard let currentUser = Auth.auth().currentUser else {
            print("Couldn't get current user")
            return
        }
        
        currentUser.delete { error in
            if let error = error {
                print("deleteCurrentUser(): There was an error while deleting the user: \(error.localizedDescription)")
            }
            return
        }
        
        print("deleteCurrentUser(): Succesfully deleted the current user")
    }
    
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        do {
            try await authDataResult.user.sendEmailVerification()
        } catch {
            print("createUser() error: \(error.localizedDescription)")
        }
        
        print(authDataResult.user.isEmailVerified.description)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    @discardableResult
    func signIn(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            //Handle Error Properly
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultModel(user: user)
    }
    
    func sendPasswordResetEmail(userEmail: String) {
        Auth.auth().sendPasswordReset(withEmail: userEmail) { error in
            print("sendPasswordResetEmail() error: \(String(describing: error?.localizedDescription))")
        }
    }
}
