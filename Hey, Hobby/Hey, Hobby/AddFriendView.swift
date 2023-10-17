//
//  AddFriendView.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 10/14/23.
//

import SwiftUI
    
struct AddFriendView: View {
    @EnvironmentObject var vm: UserProfileViewModel
    @State private var isFriendAdded = false
    @State private var newFriend = DBUser.sampleUser
    @State private var searchedUser = ""
    @State private var searchedUserList = [DBUser]()
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter your friend's first name", text: $searchedUser)
                    .padding()
                    .background(.gray.opacity(0.4))
                    .cornerRadius(10)
                Button {
                    Task {
                        do {
                            try await searchedUserList.append(contentsOf: UserManager.shared.getUsersBy(fieldName: "firstName", fieldValue: searchedUser))
                        }
                    }
                } label: {
                    Text("Search")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(width: 95)
                        .background(.blue)
                        .cornerRadius(10)
                }
            }
            .padding()

            List(searchedUserList, id: \.id) { user in
                HStack {
                    Text("\(user.firstName) \(user.lastName)")
                    Spacer()
                    Button("Add") {
                        newFriend = user
                        isFriendAdded = true
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
                        vm.updateFriendsIdForCurrentUserInDB(currentUserId: loggedInUser.id, friendId: vm.selectedFriendId)
                        
                        //We unsubscribe and resubscribe to notifications so that it adds a new subscription for the newly added friend
                        vm.unsubscibeToNotifications()
                        vm.subscibeToNotifications()
                        
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
