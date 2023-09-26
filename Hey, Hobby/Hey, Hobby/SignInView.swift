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
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink {
                    SignInEmailView(showSignInView: $showSignInView, showUserProfile: $showUserProfile)
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
        }
        .fullScreenCover(isPresented: $showUserProfile) {
            UserProfile(showSignInView: $showSignInView)
        }
        
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
