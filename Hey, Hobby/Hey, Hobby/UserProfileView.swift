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
//    @Binding var showUserProfile: Bool
//    @Binding var showUserDetails: Bool
//    @Binding var showWelcomeView: Bool
    @State var showEditPhoneNumberScreen = false
    @State private var showUnfriendWarning = false
    @State private var showPasswordResetText = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Manage User Settings")
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
                        
                        HStack {
                            Text("Reset Password")
                            
                            Button {
                                do {
                                    let authenticatedUser = try AuthManager.shared.getAuthenticatedUser()
                                    guard let userEmail = authenticatedUser.email else {
                                        print("There was an error authenticating the user")
                                        return
                                    }
                                    
                                    showPasswordResetText = true
                                    AuthManager.shared.sendPasswordResetEmail(userEmail: userEmail)
                                } catch {
                                    print("\(error.localizedDescription)")
                                }
                            } label: {
                                Text("Reset")
                                    .bold()
                                    .foregroundColor(.white)
                                    .frame(height: 25)
                                    .frame(width: 50)
                                    .background(.blue)
                                    .cornerRadius(10)
                            }
                        }
                        
                        DeleteUserView()
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
                            }
                            .foregroundColor(.blue)
                        }
                    }
                }
                
                Seperator(width: 250)
                
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
            .alert("Reset Password", isPresented: $showPasswordResetText) {
                Button("Ok") {}
            } message: {
                Text("A link has been sent to your email. Please click on the link to reset your password.")
            }
        }
    }
}

struct DeleteUserView: View {
    @State private var showSignInView = false
//    @Binding var showUserProfile: Bool
//    @Binding var showUserDetails: Bool
//    @Binding var showWelcomeView: Bool
    //@State private var showSignInView2 = false
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        HStack {
            Text("Delete user")
            Button("Delete", role: .destructive) {
                showDeleteConfirmation = true
            }
        }
        /*
         We are callig SignInView() in fullScreenCover() instead of directly from "delete" button
         This is because we cannot call a view from a button click
         Another option for this is to use a NavigationLink instead of inside the "delete" button
         This won't work because you cannot use a NavigationLink inside of an alert
         */
        .fullScreenCover(isPresented: $showSignInView) {
            SignInView()
        }
        .alert("Delete User", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                Task {
                    do {
                        let authenticatedUser = try AuthManager.shared.getAuthenticatedUser()
                        await UserManager.shared.deleteUserDocument(documentId: authenticatedUser.uid)
                        await AuthManager.shared.deleteCurrentUser()
                        showSignInView = true
                    } catch {
                        print("DeleteUserView() error: \(error.localizedDescription)")
                    }
                }
            }
        } message: {
            Text("Once you delete, you will have to sign up again to use this app. Are you sure you want to delete?")
        }

    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile(showSignInView: .constant(true))
    }
}
