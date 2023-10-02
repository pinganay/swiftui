//
//  ContentView.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 9/17/23.
//

import SwiftUI

@MainActor final class UserProfileViewModel: ObservableObject {
//    var loggedIUser: DBUser {
//        let authenticatedUser = try? AuthManager.shared.getAuthenticatedUser()
//        var user = Any.self
//
//        guard let authenticatedUser = authenticatedUser else {
//            print("UserProfileViewModel Error: failed to get authenticated user")
//        }
//
//        Task {
//            user = try? await readUserData(userId: authenticatedUser.uid)
//        }
//
//        return user
//    }
    
    @Published var userList = [DBUser]()
    @Published var friendsList = [DBUser]()
    @Published var selectedFriendId = "" {
        didSet {
            Task {
                let user = try await readUserData(userId: selectedFriendId)
                let isDuplicate = searchFor(user: user, in: friendsList)
                if isDuplicate {
                    print("UserProfileViewModel Error: User already in friends list")
                } else {
                    friendsList.append(user)
                    let currentUser = await readCurrentUser()
                    updateFriendsIdForCurrentUserInDB(currentUserId: currentUser.id)
                }
            }
        }
    }
    
    func updateFriendsIdForCurrentUserInDB(currentUserId: String) {
        UserManager.shared.updateFriendsIdForCurrentUser(friendId: selectedFriendId, currentUserId: currentUserId)
    }
    
    func readCurrentUser() async -> DBUser {
        do {
            let authenticatedUser = try AuthManager.shared.getAuthenticatedUser()
            let currentUser = try await UserManager.shared.readUserData(userId: authenticatedUser.uid)
            return currentUser
        } catch {
            print("UserProfileViewModel Error: \(error.localizedDescription)")
            return DBUser.sampleUser
        }
    }
    
    func searchFor(user: DBUser, in userList: [DBUser]) -> Bool {
        if userList.contains(user) {
            return true
        }
        
        return false
    }
    
    func getLoggedInUser() async -> DBUser {
        let readUserDataTask = Task { () -> DBUser in
            do {
                let authenticatedUser = try AuthManager.shared.getAuthenticatedUser()
                let user = try await readUserData(userId: authenticatedUser.uid)
                
                return user
            }
        }
        
        let readUserDataTaskResult = await readUserDataTask.result
        
        do {
            let dbUser = try readUserDataTaskResult.get()
            return dbUser
        } catch {
            print("UserProfileViewModel Error: \(error.localizedDescription)")
            return DBUser.sampleUser
        }
    }
    
    func signOut()  {
        do {
            try AuthManager.shared.signOut()
        } catch {
            print(error)
        }
    }
    
    func loadCurrentUserFriendsList(userIdList: [String]) {
        for id in userIdList {
            Task {
                do {
                    let user = try await readUserData(userId: id)
                    friendsList.append(user)
                } catch {
                    print("UserProfileViewModel Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func readUserData(userId: String) async throws -> DBUser {
        
        let readUserDataTask =  Task { () -> DBUser in
            let user = try await UserManager.shared.readUserData(userId: userId)
            return user
        }
        
        let readUserDataTaskResult = await readUserDataTask.result
        
        do {
            let dbUser = try readUserDataTaskResult.get()
            return dbUser
        } catch {
            print("UserProfileView Error: \(error.localizedDescription)")
            return DBUser.sampleUser
        }
    }
    
    func getAllUsers() {
        Task {
            do {
                userList = try await UserManager.shared.readAllUsers()
            } catch {
                print("There was an error: \(error.localizedDescription)")
            }
        }
        
        
    }
}

struct UserProfile: View {
    @StateObject var viewModel = UserProfileViewModel()
    @Binding var showSignInView: Bool
    @State var loggedInUser: DBUser = DBUser.sampleUser
//        let getLoggedInUserTask = Task { () -> DBUser in
//           return await viewModel.getLoggedInUser()
//        }
//
//        let getLoggedInUserTaskResult = await getLoggedInUserTask.result
//
//        do {
//                let dbUser = try getLoggedInUserTaskResult.get()
//                return dbUser
//        } catch {
//            print("UserProfileVIew: \(error.localizedDescription)")
//        }
    
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Hey, \(loggedInUser.firstName) \(loggedInUser.lastName)")
                    .padding(.trailing, 225)
                    .font(.title)
                    
                
                Picker("People", selection: $viewModel.selectedFriendId) {
                    ForEach(viewModel.userList, id: \.id) { user in
                        Text(user.firstName)
                    }
                }
                .pickerStyle(.menu)
                
                
                Text("Friends")
                    .padding(.trailing, 225)
                    .font(.title)
                
                Seperator(width: 250)
                
                VStack {
                    ForEach(viewModel.friendsList, id: \.id) { friend in
                        Text(friend.firstName + " " + friend.lastName)
                    }
                }
            }
            .onAppear {
                viewModel.getAllUsers()
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

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile(showSignInView: .constant(true))
    }
}
