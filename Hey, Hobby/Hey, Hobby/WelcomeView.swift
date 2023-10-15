//
//  WelcomeView.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 10/12/23.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var vm: UserProfileViewModel
    @State var currentUser = DBUser.sampleUser
    
    @Binding var showSignInView: Bool
    @Binding var showUserProfile: Bool
    @Binding var showUserDetails: Bool
    @Binding var showWelcomeView: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome, \(currentUser.firstName) \(currentUser.lastName)!")
                    .font(.largeTitle)
                
                Spacer()
                
                HStack {
                    NavigationLink {
                        UserProfile(showSignInView: $showSignInView)
                    } label: {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding([.leading, .top])
                    }
                    
                    Spacer()
                    
                    NavigationLink("Add Friend") {
                        AddFriendView()
                    }
                    .font(.headline)
                    .padding([.trailing, .top])
                }
                .background(.gray.opacity(0.7))
            }
            .navigationTitle("Hey, Hobby!")
        }
        .task {
            let authenticatedUser = try? AuthManager.shared.getAuthenticatedUser()
            showUserProfile = authenticatedUser != nil
            showSignInView = !showUserProfile
            showUserDetails = false
            
            currentUser = await vm.readCurrentUser()
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(showSignInView: .constant(false), showUserProfile: .constant(false), showUserDetails: .constant(false), showWelcomeView: .constant(false))
    }
}
