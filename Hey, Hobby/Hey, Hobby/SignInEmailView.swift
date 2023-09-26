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
    @State var showUserDetails = false
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Email...", text: $viewModel.email)
                    .padding()
                    .background(.gray.opacity(0.4))
                    .cornerRadius(10)
                SecureField("Password...", text: $viewModel.password)
                    .padding()
                    .background(.gray.opacity(0.4))
                    .cornerRadius(10)
                
                Button {
                    Task {
                        do {
                            try await viewModel.signUp()
//                            showUserProfile = true
                            showUserDetails = true
                            showSignInView = false
                            return
                        } catch {
                            print("SignInEmailView: Sign up failed, \(error.localizedDescription)")
                        }
                        
                        do {
                            try await viewModel.signIn()
                            showUserProfile = true
                            showSignInView = false
                            return
                        } catch {
                            print("SignInEmailView: Sign in failed, \(error.localizedDescription)")
                        }
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
                
                
                Spacer()
            }
            .padding()
            .navigationTitle("Sign In With Email")
            .fullScreenCover(isPresented: $showUserProfile) {
                UserProfile(showSignInView: $showSignInView)
            }
            .fullScreenCover(isPresented: $showUserDetails) {
                UserDetailsView()
            }
        }
    }
}

struct SignInEmailView_Previews: PreviewProvider {
    static var previews: some View {
        SignInEmailView(showSignInView: .constant(true), showUserProfile: .constant(false))
    }
}
