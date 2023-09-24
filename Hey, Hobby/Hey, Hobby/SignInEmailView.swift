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
    
    
    func createUser() {
        guard !email.isEmpty, !password.isEmpty else {
            print("Email or password is empty")
            return
        }
        
        Task {
            do {
                let returnedUserData = try await AuthManager.shared.createUser(email: email, password: password)
                print("Successfully created user")
                print(returnedUserData)
            } catch {
                print(error)
            }
        }
    }
}

struct SignInEmailView: View {
    @StateObject var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    @State var showUserProfile = false
    
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
                    viewModel.createUser()
                    showUserProfile = true
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
//            .onAppear {
//                let authenticatedUser = try? AuthManager.shared.getAuthenticatedUser()
//                showSignInView = authenticatedUser == nil
//            }
//            .fullScreenCover(isPresented: $showSignInView) {
//                //UserProfile(showSignInView: $showSignInView)
//            }
        }
    }
}

struct SignInEmailView_Previews: PreviewProvider {
    static var previews: some View {
        SignInEmailView(showSignInView: .constant(true))
    }
}
