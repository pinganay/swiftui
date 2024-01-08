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
//    @State private var loadFriendsListFromDB = true
    
    @Binding var showSignInView: Bool
    @Binding var showUserProfile: Bool
    @Binding var showUserDetails: Bool
    @Binding var showWelcomeView: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                //If loading the user info takes too long, this displays the loading view
                if currentUser.firstName == "Dummy" {
                    LoadingView()
                } else {
                    Text("Hey, \(currentUser.firstName) \(currentUser.lastName)")
                        .font(.largeTitle)
                }
                
                Spacer()
                
                HStack {
                    NavigationLink {
                        UserProfile(showSignInView: $showSignInView, showUserProfile: $showUserProfile, showUserDetails: $showUserDetails, showWelcomeView: $showWelcomeView)
                    } label: {
                        VStack(alignment: .center) {
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding([.top])
                            
                            Text("Profile")
                                .font(.system(size: 10))
                        }
                        .padding(.leading)
                    }
                    
                    Spacer()
                    
                    NavigationLink {
                        MessagingView()
                    } label: {
                        VStack(alignment: .center) {
                            Image(systemName: "plus.message.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding([.top])
                            
                            Text("Set Status")
                                .font(.system(size: 10))
                        }
                        .padding(.leading)
                    }

                    
                    Spacer()
                    
                    NavigationLink {
                        AddFriendView()
                    } label: {
                        VStack {
                            Image(systemName: "person.3.fill")
                                .resizable()
                                .frame(width: 66, height: 40)
                                .padding([.top])
                            
                            Text("Add Friend")
                                .font(.system(size: 10))
                        }
                    }
                    .padding(.trailing)
                }
                .background(.gray.opacity(0.7))
            }
            .navigationTitle("Hey, Hobby!")
            .toolbar {
                ToolbarItem {
                    Button("Log Out", role: .destructive) {
                        vm.signOut()
                        print("Succesfully Logged out User")
                        showSignInView = true
                    }
                    
                }
            }
            .fullScreenCover(isPresented: $showSignInView) {
                SignInView()
            }
        }
        .task {
            let authenticatedUser = try? AuthManager.shared.getAuthenticatedUser()
            showUserProfile = authenticatedUser != nil
            showSignInView = !showUserProfile
            showUserDetails = false
            
            currentUser = await vm.readCurrentUser()
            
            //should be called once
            if vm.loadFriendsListFromDB {
                vm.loadCurrentUserFriendsList(userIdList: currentUser.friendsId)
                vm.loadFriendsListFromDB = false
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(showSignInView: .constant(false), showUserProfile: .constant(false), showUserDetails: .constant(false), showWelcomeView: .constant(false))
    }
}
