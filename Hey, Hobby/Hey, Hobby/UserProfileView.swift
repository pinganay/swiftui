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
    @State var showEditPhoneNumberScreen = false
    @State private var showUnfriendWarning = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Settings")
                    .padding(.trailing, 5)
                    .padding()
                    .font(.largeTitle)
                
                //If loading the user info takes too long, this displays the loading view
                if vm.loggedInUser.firstName == "Dummy" {
                    LoadingView()
                } else {
                    VStack(alignment: .leading) {
                        Text("First Name: \(vm.loggedInUser.firstName)")
                        Text("Last Name: \(vm.loggedInUser.lastName)")
                        HStack {
                            Text("Phone Number: \(vm.loggedInUser.phoneNumber)")
                            
                            Button {
                                showEditPhoneNumberScreen = true
                            } label: {
                                Text("Edit")
                                    .bold()
                                    .foregroundColor(.white)
                                    .frame(height: 25)
                                    .frame(width: 50)
                                    .background(.blue)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.trailing, 125)
                }
                
                Seperator(width: 250)
                
                Text("Friends")
                    .padding(.trailing, 5)
                    .padding()
                    .font(.largeTitle)
                
                VStack {
                    List(vm.friendsList, id: \.id) { friend in
                        HStack {
                            Text(friend.firstName + " " + friend.lastName)
                            
                            Spacer()
                            
                            Button("Unfriend") {
                                showUnfriendWarning = true
//                                vm.friendsList.removeAll { user in
//                                    user.id == friend.id
//                                }
//
//                                vm.isFriendAdded = false
//                                vm.removeFriendsIdForCurrentUserInDB(currentUserId: vm.loggedInUser.id, friendId: friend.id)
//
//                                vm.unsubscibeToNotifications()
//                                vm.subscibeToNotifications()
//                                vm.isUserSubscribed = true
                            }
                            .foregroundColor(.blue)
                        }
                    }
                }
                
                Seperator(width: 250)
                
                
//                    Text("Recieved Messages")
//                        .padding(.trailing, 5)
//                        .font(.largeTitle)
//                    
//                    ForEach(vm.messageList, id: \.self) { message in
//                        Text(message)
//                    }

                
                Section {
                    Button("Request notification Permissions") {
                        vm.requestNotificationPermissions()
                    }
                    
                    Button("Subscribe to notificatios") {
                        vm.subscibeToNotifications()
                        vm.isUserSubscribed = true
                    }
                    .disabled(vm.isUserSubscribed)
                    
                    Button("Unsubscribe to notificatios") {
                        vm.unsubscibeToNotifications()
                        vm.isUserSubscribed = false
                    }
                    .disabled(!vm.isUserSubscribed)
                }
                
                Spacer()
                
            }
            .onAppear {
                vm.getAllUsersWithoutCurrentUser()
            }
            .navigationTitle("Profile")
            .task {
                vm.loggedInUser = await vm.getLoggedInUser()
            }
            .fullScreenCover(isPresented: $showSignInView) {
                SignInView()
            }
            .sheet(isPresented: $showEditPhoneNumberScreen) {
                EditPhoneNumberView()
            }
            .alert("Unfriend", isPresented: $showUnfriendWarning) {
                Button("Unfriend", role: .destructive) {
                    for friend in vm.friendsList {
                        vm.friendsList.removeAll { user in
                            user.id == friend.id
                        }
                        
                        vm.isFriendAdded = false
                        vm.removeFriendsIdForCurrentUserInDB(currentUserId: vm.loggedInUser.id, friendId: friend.id)
                        
                        vm.unsubscibeToNotifications()
                        vm.subscibeToNotifications()
                        vm.isUserSubscribed = true
                    }
                }
                
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to unfriend this user?")
            }
        }
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile(showSignInView: .constant(true))
    }
}
