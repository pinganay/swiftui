//
//  SignInEmailView.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 9/23/23.
//

import SwiftUI

@MainActor final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    var authenticatedUser = try? AuthManager.shared.getAuthenticatedUser()
    @Published var emailVerificationText = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("Email or password is empty")
            return
        }
        
        let returnedUserData = try await AuthManager.shared.createUser(email: email, password: password)
        print("SignInEmailViewModel: Successfully created user")
        print(returnedUserData)
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("Email or password is empty")
            return
        }
        
        try await AuthManager.shared.signIn(email: email, password: password)
        print("SignInEmailViewModel: Successfully logged in user")
    }
}

struct SignInEmailView: View {
    @StateObject var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    @Binding var showUserProfile: Bool
    @Binding var showUserDetails: Bool
    @Binding var showWelcomeView: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Email...", text: $viewModel.email)
                    .padding()
                    .background(.gray.opacity(0.4))
                    .cornerRadius(10)
                    .keyboardType(.emailAddress)
                
                Text("Password should have 6 digits or more")
                    .font(.caption)
                
                SecureField("Password...", text: $viewModel.password)
                    .padding()
                    .background(.gray.opacity(0.4))
                    .cornerRadius(10)
                
                Button {
                    Task {
                        do {
                            try? await viewModel.signIn()
                            
                            viewModel.authenticatedUser = try? AuthManager.shared.getAuthenticatedUser()
                            
                            guard let authenticatedUser = viewModel.authenticatedUser else {
                                print("Could not authenticate user")
                                try await viewModel.signUp()
                                viewModel.authenticatedUser = try? AuthManager.shared.getAuthenticatedUser()
                                showUserDetails = true
                                showSignInView = false
                                showUserProfile = false
                                showWelcomeView = false
                                viewModel.emailVerificationText = "A verfication link has been sent to your email. Please click on the link to verify and login again."
                                return
                            }
                            
                            if authenticatedUser.isEmailVerified {
//                                try await viewModel.signIn()
                                showUserDetails = false
                                showSignInView = false
                                showUserProfile = false
                                showWelcomeView = true
                                viewModel.emailVerificationText = ""
                            } else {
                                viewModel.emailVerificationText = "A verfication link has been sent to your email. Please click on the link to verify and login again."
                            }
                            
                            return
                        } catch {
                            print("SignInEmailView: Sign up failed, \(error.localizedDescription)")
                        }
                        
//                        do {
//                            try await viewModel.signIn()
//                            showWelcomeView = true
//                            showSignInView = false
//                            showUserDetails = false
//                            showUserProfile = false
//                            return
//                        } catch {
//                            print("SignInEmailView: Sign in failed, \(error.localizedDescription)")
//                        }
                    }
                } label: {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(.blue)
                        .cornerRadius(10)
                }
                
                Text(viewModel.emailVerificationText)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Sign In With Email")
            .fullScreenCover(isPresented: $showUserProfile) {
                UserProfile(showSignInView: $showSignInView)
            }
        }
    }
}

struct SignInEmailView_Previews: PreviewProvider {
    static var previews: some View {
        SignInEmailView(showSignInView: .constant(true), showUserProfile: .constant(false), showUserDetails: .constant(false), showWelcomeView: .constant(false))
    }
}
