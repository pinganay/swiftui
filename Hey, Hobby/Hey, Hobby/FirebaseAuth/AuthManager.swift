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
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
    }
    
}

final class AuthManager {
    static let shared = AuthManager()
    private init() {}
    
    func createUser(email: String, password: String) async throws -> AuthDataResultModel{
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel{
        guard let user = Auth.auth().currentUser else {
            //Handle Error Properly
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultModel(user: user)
    }
}
