//
//  ContentView.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 9/17/23.
//

import SwiftUI
import CloudKit

struct UserProfile: View {
    @StateObject var viewModel = UserProfileViewModel()
    @Binding var showSignInView: Bool
    @State var loggedInUser: DBUser = DBUser.sampleUser
    var array = ["Bob", "aa", "bb"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Hey, \(loggedInUser.firstName) \(loggedInUser.lastName)")
                        .padding(.trailing, 225)
                        .font(.largeTitle)
                    
                    //Spacer()
                        
                    
                    Picker("People", selection: $viewModel.selectedFriendId) {
                        ForEach(viewModel.userList, id: \.id) { user in
                            Text(user.firstName)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    Section {
                        Text("Friends")
                            .padding(.trailing, 5)
                            .padding()
                            .font(.largeTitle)
                        
                        VStack {
                            ForEach(viewModel.friendsList, id: \.id) { friend in
                                Text(friend.firstName + " " + friend.lastName)
                            }
                        }
                    }
                        
                    Seperator(width: 250)
                    
                    Section {
                        Text("Message your Friends")
                            .padding(.trailing, 5)
                            .font(.largeTitle)
                        
                        TextField("Enter Message", text: $viewModel.userMessage)
                            .font(.headline)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(.gray.opacity(0.4))
                            .cornerRadius(10)
                            .padding()
                        
                        Button("Send Message") {
                            viewModel.addMessage(message: viewModel.userMessage)
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
                        
                        ForEach(viewModel.messageList, id: \.self) { message in
                            Text(message)
                        }
                    }
                    
                    Section {
                        Button("Request notification Permissions") {
                            viewModel.requestNotificationPermissions()
                        }
                        
                        Button("Subscribe to notificatios") {
                            viewModel.subscibeToNotifications()
                        }
                        
                        Button("Unsubscribe to notificatios") {
                            viewModel.unsubscibeToNotifications()
                        }
                    }
                    
                    Spacer()
                    
                }
                .onAppear {
                    //when this view loaded, get all users from DB and display them
                    viewModel.getAllUsersWithoutCurrentUser()
                }
                .navigationTitle("Profile")
                .task {
                    loggedInUser = await viewModel.getLoggedInUser()
                }
                .toolbar {
                    ToolbarItem {
                        Button("Log Out", role: .destructive) {
                            viewModel.signOut()
                            print("Succesfully Logged out User")
                            showSignInView = true
                        }

                    }
                }
                .fullScreenCover(isPresented: $showSignInView) {
                    SignInView()
                }
                .task {
                    let currentUser = await viewModel.readCurrentUser()
                    viewModel.loadCurrentUserFriendsList(userIdList: currentUser.friendsId)
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
