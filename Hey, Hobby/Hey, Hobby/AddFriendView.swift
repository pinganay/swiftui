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
//                        vm.friendsList.append(user)
//                        searchedUserList.removeAll { searchedUser in
//                            searchedUser.id == user.id
//                        }
                        newFriend = user
                        isFriendAdded = true
                    }
                }
            }
            .alert("Add Friend", isPresented: $isFriendAdded) {
                Button("OK") {
                    Task {
                        let loggedInUser = await vm.getLoggedInUser()
                        vm.friendsList.append(newFriend)
                        vm.updateFriendsIdForCurrentUserInDB(currentUserId: loggedInUser.id, friendId: newFriend.id)
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
