//
//  AuthView.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 9/23/23.
//

import SwiftUI

struct SignInView: View {
    @State var showSignInView = true
    @State var showWelcomeView = false
    @State var showUserProfile = false
    @State var showUserDetails = false
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink {
                    SignInEmailView(showSignInView: $showSignInView, showUserProfile: $showUserProfile, showUserDetails: $showUserDetails, showWelcomeView: $showWelcomeView)
                } label: {
                    Text("Sign In With Email")
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
            .navigationTitle("Sign In")
        }
        .onAppear {
            let authenticatedUser = try? AuthManager.shared.getAuthenticatedUser()
            showWelcomeView = authenticatedUser != nil
            showSignInView = false
            showUserDetails = false
            showUserProfile = false
        }
        .fullScreenCover(isPresented: $showWelcomeView) {
            WelcomeView(showSignInView: $showSignInView, showUserProfile: $showUserProfile, showUserDetails: $showUserDetails, showWelcomeView: $showWelcomeView)
        }
        .fullScreenCover(isPresented: $showUserDetails) {
            UserDetailsView(showUserProfile: $showUserProfile, showUserDetails: $showUserDetails, showSignInView: $showSignInView, showWelcomeView: $showWelcomeView)
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
