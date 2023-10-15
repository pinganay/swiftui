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
                    
                    Picker("People", selection: $vm.selectedFriendId) {
                        ForEach(vm.userList, id: \.id) { user in
                            Text(user.firstName + user.lastName)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    Section {
                        Text("Friends")
                            .padding(.trailing, 5)
                            .padding()
                            .font(.largeTitle)
                        
                        VStack {
                            ForEach(vm.friendsList, id: \.id) { friend in
                                Text(friend.firstName + " " + friend.lastName)
                            }
                        }
                    }
                        
                    Seperator(width: 250)
                    
                    Section {
                        Text("Message your Friends")
                            .padding(.trailing, 5)
                            .font(.largeTitle)
                        
                        TextField("Enter Message", text: $vm.userMessage)
                            .font(.headline)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(.gray.opacity(0.4))
                            .cornerRadius(10)
                            .padding()
                        
                        Button("Send Message") {
                            let loggedInUserFullName = "\(loggedInUser.firstName) \(loggedInUser.lastName)"
                            vm.addMessage(message: vm.userMessage, userId: loggedInUser.id, currentUserName: loggedInUserFullName)
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(.blue)
                        .cornerRadius(10)
                        .padding(.horizontal, 130)
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
                .task {
                    let currentUser = await vm.readCurrentUser()
                    vm.loadCurrentUserFriendsList(userIdList: currentUser.friendsId)
                }
            }
        }
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile(showSignInView: .constant(true))
    }
}
