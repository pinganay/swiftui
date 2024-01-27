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
        NavigationStack {
            VStack {
                NavigationLink {
                    SignInEmailView(showSignInView: $showSignInView, showUserProfile: $showUserProfile, showUserDetails: $showUserDetails, showWelcomeView: $showWelcomeView)
                } label: {
                    Text("Sign In With Email")
                        .buttonModifier(width: 400, height: 50)
                }
                
                Spacer()
            }
            .padding()
            // Use toolbar instead of .navigationTitle, so that font can be customized
            .toolbar {
                ToolbarItem(placement: .principal) { // <3>
                    VStack {
                        Text("Sign In")
                            .foregroundColor(.white)
                            .font(.titleScript)
                    }
                }
            }
            .background(.themeColor)
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
