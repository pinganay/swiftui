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
            VStack {
//                TextField("Enter your friend's first name", text: $searchedUserFirstName)
//                    .padding()
//                    .background(.gray.opacity(0.4))
//                    .cornerRadius(10)
//
//                TextField("Enter your friend's last name", text: $searchedUserLastName)
//                    .padding()
//                    .background(.gray.opacity(0.4))
//                    .cornerRadius(10)

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
                    .font(.caption)
                    .foregroundColor(.red)
            }
            .padding()
            
//            Button {
//                Task {
//                    do {
////                        searchedUserList = try await UserManager.shared.getUsersBy(fNameField: "firstName", fNameValue: searchedUserFirstName, lNameField: "lastName", lNameValue: searchedUserLastName, phoneNumberField: "phoneNumber", phoneNumberValue: searchedUserPhoneNumber)
//
//                        searchedUserList = try await UserManager.shared.getUsersByEmailAndPhoneNumber(emailValue: searchedUserEmail, phoneNumberValue: searchedUserPhoneNumber)
//                    } catch {
//                        print("Error: \(error.localizedDescription)")
//                    }
//                }
//            } label: {
//                Text("Search")
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .frame(height: 55)
//                    .frame(width: 200)
//                    .background(.blue)
//                    .cornerRadius(10)
//            }
            
            Button("Search") {
                Task {
                    do {
                        //searchedUserList = try await UserManager.shared.getUsersBy(fNameField: "firstName", fNameValue: searchedUserFirstName, lNameField: "lastName", lNameValue: searchedUserLastName, phoneNumberField: "phoneNumber", phoneNumberValue: searchedUserPhoneNumber)
                        
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
                        Button("Add") {
                            newFriend = user
                            isFriendAdded = true
                        }
                    }
                }
            }
            .alert("Add Friend", isPresented: $isFriendAdded) {
                Button("OK") {
                    Task {
                        //We get the user and add them to the friend list of the current user
                        let loggedInUser = await vm.getLoggedInUser()
                        vm.selectedFriendId = newFriend.id
                        vm.friendsList.append(newFriend)
                        
                        //We update the friend list of the current user in the Firstore DB
                        vm.isFriendAdded = true
                        vm.addFriendsIdForCurrentUserInDB(currentUserId: loggedInUser.id, friendId: vm.selectedFriendId)
                        
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
        }
        .navigationTitle("Add Friends")
    }
}

struct AddFriendView_Previews: PreviewProvider {
    static var previews: some View {
        AddFriendView()
    }
}
