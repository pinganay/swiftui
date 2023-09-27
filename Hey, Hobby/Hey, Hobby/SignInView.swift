//
//  AuthView.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 9/23/23.
//

import SwiftUI

struct SignInView: View {
    @State var showSignInView = true
    @State var showUserProfile = false
    @State var showUserDetails = false
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink {
                    SignInEmailView(showSignInView: $showSignInView, showUserProfile: $showUserProfile, showUserDetails: $showUserDetails)
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
            showUserProfile = authenticatedUser != nil
            showSignInView = !showUserProfile
            showUserDetails = false
        }
        .fullScreenCover(isPresented: $showUserProfile) {
            UserProfile(showSignInView: $showSignInView)
        }
        .fullScreenCover(isPresented: $showUserDetails) {
            UserDetailsView(showUserProfile: $showUserProfile, showUserDetails: $showUserDetails, showSignInView: $showSignInView)
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
