//
//  ContentView.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 9/17/23.
//

import SwiftUI
import CloudKit

struct UserProfile: View {
    @EnvironmentObject var vm: UserProfileViewModel
    @Binding var showSignInView: Bool
    @State var loggedInUser: DBUser = DBUser.sampleUser
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Hey, \(loggedInUser.firstName) \(loggedInUser.lastName)")
                        .padding(.trailing, 225)
                        .font(.largeTitle)
                    
                    Text("Friends")
                        .padding(.trailing, 5)
                        .padding()
                        .font(.largeTitle)
                    
                    VStack {
                        ForEach(vm.friendsList, id: \.id) { friend in
                            Text(friend.firstName + " " + friend.lastName)
                        }
                    }
                    Seperator(width: 250)
                    
                    Section {
                        Text("Recieved Messages")
                            .padding(.trailing, 5)
                            .font(.largeTitle)
                        
                        ForEach(vm.messageList, id: \.self) { message in
                            Text(message)
                        }
                    }
                    
                    Section {
                        Button("Request notification Permissions") {
                            vm.requestNotificationPermissions()
                        }
                        
                        Button("Subscribe to notificatios") {
                            vm.subscibeToNotifications()
                        }
                        
                        Button("Unsubscribe to notificatios") {
                            vm.unsubscibeToNotifications()
                        }
                    }
                    
                    Spacer()
                    
                }
                .onAppear {
                    //when this view loaded, get all users from DB and display them
                    vm.getAllUsersWithoutCurrentUser()
                }
                .navigationTitle("Profile")
                .task {
                    loggedInUser = await vm.getLoggedInUser()
                }
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
//                .task {
//                    let currentUser = await vm.readCurrentUser()
//                    vm.loadCurrentUserFriendsList(userIdList: currentUser.friendsId)
//                }
            }
        }
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile(showSignInView: .constant(true))
    }
}
