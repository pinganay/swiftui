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
            VStack {
                Text("Hey, \(loggedInUser.firstName) \(loggedInUser.lastName)")
                    .padding(.trailing, 225)
                    .font(.largeTitle)
                
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
                                vm.friendsList.removeAll { user in
                                    user.id == friend.id
                                }
                                
                                vm.updateFriendsIdForCurrentUserInDB(currentUserId: loggedInUser.id, friendId: friend.id)
                                
                                vm.unsubscibeToNotifications()
                                vm.subscibeToNotifications()
                                vm.isUserSubscribed = true
                            }
                            .foregroundColor(.blue)
                        }
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
                loggedInUser = await vm.getLoggedInUser()
            }
            .fullScreenCover(isPresented: $showSignInView) {
                SignInView()
            }
        }
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile(showSignInView: .constant(true))
    }
}
