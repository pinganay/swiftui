//
//  AddFriendView.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 10/14/23.
//

import SwiftUI

@MainActor class AddFriendViewModel: ObservableObject {
    @Published var disableSearchButton = true
    @Published var searchedUserPhoneNumber = ""
    @Published var searchedUserEmail = ""
    
    
    func validateFriendDetails() {
        if (searchedUserEmail.isEmpty && searchedUserPhoneNumber.isEmpty) || searchedUserEmail.containsWhitespace || searchedUserPhoneNumber.containsWhitespace {
            disableSearchButton = true
        } else {
            disableSearchButton = false
        }
    }
}

struct AddFriendView: View {
    @EnvironmentObject var vm: UserProfileViewModel
    @State private var isFriendAdded = false
    @State private var newFriend = DBUser.sampleUser
    //    @State private var searchedUserFirstName = ""
    //    @State private var searchedUserLastName = ""
    //    @State private var searchedUserPhoneNumber = ""
    //    @State private var searchedUserEmail = ""
    @State private var searchedUserList = [DBUser]()
    @StateObject var addFriendVM = AddFriendViewModel()
    @State private var userNotFoundText = ""
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    TextField("Enter your friend's phone number", text: $addFriendVM.searchedUserPhoneNumber)
                        .padding()
                        .background(.gray.opacity(0.4))
                        .cornerRadius(10)
                        .keyboardType(.numberPad)
                        .onChange(of: addFriendVM.searchedUserPhoneNumber) { _ in
                            addFriendVM.validateFriendDetails()
                        }
                    
                    Text("OR")
                        .font(.title3)
                    
                    TextField("Enter your friend's email address", text: $addFriendVM.searchedUserEmail)
                        .padding()
                        .background(.gray.opacity(0.4))
                        .cornerRadius(10)
                        .onChange(of: addFriendVM.searchedUserEmail) { _ in
                            addFriendVM.validateFriendDetails()
                        }
                        .keyboardType(.emailAddress)
                    
                    Text(addFriendVM.disableSearchButton ? "Fields cannot be empty or have space" : "")
                        .warningModifier()
                }
                .padding()
                
                Button("Search") {
                    Task {
                        do {
                            searchedUserList = try await UserManager.shared.getUsersByEmailAndPhoneNumber(emailValue: addFriendVM.searchedUserEmail, phoneNumberValue: addFriendVM.searchedUserPhoneNumber)
                            
                            userNotFoundText = searchedUserList.isEmpty ? "User Not Found" : ""
                        } catch {
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(height: 55)
                .frame(width: 200)
                .background(addFriendVM.disableSearchButton ? .gray : .accentColor)
                .cornerRadius(10)
                .disabled(addFriendVM.disableSearchButton)
                
                Text(userNotFoundText)
                    .font(.caption)
                    .foregroundColor(.red)
                
                List(searchedUserList, id: \.id) { user in
                    HStack {
                        Text("\(user.firstName) \(user.lastName)")
                        
                        Spacer()
                        
                        if vm.isUserAlreadyFriend(searchedUser: user) {
                            Text("User is already a friend")
                                .font(.system(size: 12))
                                .foregroundColor(.red)
                        } else {
                            Button("Send Request") {
                                newFriend = user
                                isFriendAdded = true
                            }
                            .buttonModifier(width: 125)
                        }
                    }
                    .listRowBackground(Color("AppIconColor"))
                }
                .frame(height: 80)
                .overlay(Section {
                    if(searchedUserList.isEmpty) {
                        ZStack {
                            Color.themeColor.ignoresSafeArea()
                        }
                    }
                })
                .listStyle(.inset)
                .background(.themeColor)
                .scrollContentBackground(.hidden)
                .alert("Add Friend", isPresented: $isFriendAdded) {
                    Button("OK") {
                        Task {
                            //We get the user and add them to the friend list of the current user
                            let loggedInUser = await vm.getLoggedInUser()
                            vm.selectedFriendId = newFriend.id
                            //vm.friendsList.append(newFriend)
                            
                            //We update the friend list of the current user in the Firstore DB
                            vm.isFriendAdded = true
                            UserManager.shared.updateRequestsForFriendApproval(friendId: vm.selectedFriendId)
                            //vm.addFriendsIdForCurrentUserInDB(currentUserId: loggedInUser.id, friendId: vm.selectedFriendId)
                            
                            //We unsubscribe and resubscribe to notifications so that it adds a new subscription for the newly added friend
                            vm.unsubscibeToNotifications()
                            vm.subscibeToNotifications()
                            vm.isUserSubscribed = true
                            
                            //We remove the newly added user from the filtered result
                            searchedUserList.removeAll { searchedUser in
                                searchedUser.id == newFriend.id
                            }
                        }
                    }
                    
                    Button("Cancel", role: .cancel) {
                        newFriend = DBUser.sampleUser
                    }
                } message: {
                    Text("Are you sure you want to add \(newFriend.firstName) \(newFriend.lastName) to your friends list?")
                }
                
                Seperator(width: 250)
                
                FriendRequestsView()
            }
            .background(.themeColor)
            //.navigationTitle("Add Friends")
            // Use toolbar instead of .navigationTitle, so that font can be customized
            .toolbar {
                ToolbarItem(placement: .principal) { // <3>
                    VStack {
                        Text("Add Friends")
                            .foregroundColor(.white)
                            .font(.titleScript)
                    }
                }
            }
        }
    }
}

struct FriendRequestsView: View {
    @StateObject var addFriendVM = AddFriendViewModel()
    @EnvironmentObject var vm: UserProfileViewModel
    @State private var sentRequestDBUSers = [DBUser]()
    @State private var recievedRequestDBUSers = [DBUser]()
    @State var currentUser = DBUser.sampleUser
    
    var body: some View {
        Group {
            Text("Friend Requests Recieved")
                .foregroundColor(.white)
                .font(.titleScript)
            
            //This List displays the friendRequestsRecieved for current user
            List(recievedRequestDBUSers, id: \.self) { user in
                HStack {
                    Text(user.firstName + user.lastName)
                    
                    Spacer()
                    
                    Button("Accept") {
                        Task {
                            currentUser = await vm.getLoggedInUser()
                            //UserManager.shared.addFriendsIdForCurrentUser(friendId: user.id, currentUserId: currentUser.id)
                            UserManager.shared.addFriendsId(forUserId: user.id, friendId: currentUser.id)
                            UserManager.shared.addFriendsId(forUserId: currentUser.id, friendId: user.id)
                            
                            UserManager.shared.deleteUserIDFromFriendRequestsRecieved(userId: currentUser.id)
                            UserManager.shared.deleteUserIDFromFriendRequestsSent(userId: user.id)
                            
                            recievedRequestDBUSers.removeAll { dbUser in
                                dbUser.id == user.id
                            }
                        }
                    }
                    .buttonModifier(width: 100)
                    
                    Button("Decline") {
                        UserManager.shared.deleteUserIDFromFriendRequestsRecieved(userId: user.id)
                        UserManager.shared.deleteUserIDFromFriendRequestsSent(userId: currentUser.id)
                    }
                    .buttonModifier(width: 100)
                }
                .listRowBackground(Color("AppIconColor"))
            }
            .frame(height: 175)
            .overlay(Section {
                if(recievedRequestDBUSers.isEmpty) {
                    ZStack {
                        Color.themeColor.ignoresSafeArea()
                    }
                }
            })
            .listStyle(.inset)
            .background(.themeColor)
            .scrollContentBackground(.hidden)
            
            Seperator(width: 250)
            
            Text("Friend Requests Sent")
                .foregroundColor(.white)
                .font(.titleScript)
            
            //This List displays the friendRequestsSent for current user
            List(sentRequestDBUSers, id: \.self) { user in
                Text(user.firstName + user.lastName)
                    .listRowBackground(Color("AppIconColor"))
            }
            .frame(height: 175)
            .overlay(Section {
                if(sentRequestDBUSers.isEmpty) {
                    ZStack {
                        Color.themeColor.ignoresSafeArea()
                    }
                }
            })
            .listStyle(.inset)
            .background(.themeColor)
            .scrollContentBackground(.hidden)
        }
        .task {
            currentUser = await vm.getLoggedInUser()
            await sentRequestDBUSers = UserManager.shared.fetchDBUsers(userIDList: currentUser.friendRequestsSent)
            await recievedRequestDBUSers = UserManager.shared.fetchDBUsers(userIDList: currentUser.friendRequestsRecieved)
            
        }
    }
}

struct AddFriendView_Previews: PreviewProvider {
    static var previews: some View {
        AddFriendView()
    }
}
