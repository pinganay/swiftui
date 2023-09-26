//
//  ContentView.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 9/17/23.
//

import SwiftUI

@MainActor final class UserProfileViewModel: ObservableObject {
    @Published var user = DBUser.sampleUser
    var userHobbies: [String] { getUserHobbies(user: user) }
    var userMemberships: [Community] { getUserMembership(user: user, communities: Community.sampleCommunities) }
    
    func signOut()  {
        do {
            try AuthManager.shared.signOut()
        } catch {
            print(error)
        }
    }
    
    func getUserHobbies(user: DBUser) -> [String] {
        var hobbies = [String]()
        
        for hobby in user.hobbies {
            switch hobby {
            case .Painting:
                hobbies.append("Painting")
            case .Soccer:
                hobbies.append("Soccer")
            case .Cricket:
                hobbies.append("Cricket")
            case .Chess:
                hobbies.append("Chess")
            }
        }
        
        return hobbies
    }
    
    func getUserMembership(user: DBUser, communities: [Community]) -> [Community] {
        var memberships = [Community]()
        
        for community in communities {
            for member in community.members {
                if user.name == member.name {
                    memberships.append(community)
                }
            }
        }
        
        return memberships
    }
}

struct UserProfile: View {
    @StateObject var viewModel = UserProfileViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                
                Text("Hey, \(viewModel.user.name)")
                    .padding(.trailing, 225)
                    .font(.title)
                
                List {
                   
                    
                    Section {
                        ForEach(viewModel.userHobbies, id: \.self) { hobby in
                            Text(hobby)
                        }
                    } header: {
                        Text("Hobbies")
                    }
                    
                    Section {
                        ForEach(viewModel.userMemberships, id: \.name) { membership in
                            Text(membership.name)
                        }
                    } header: {
                        Text("Community Memberships")
                    }
                }
                .navigationTitle("Profile")
            }
//            .task {
//                do {
//                    //try await UserManager.shared.writeUserData(user: user)
//                    //try await UserManager.shared.readUserData()
//                    //try await UserManager.shared.writeUserData(user: user)
//                    //try await UserManager.shared.readUserData(id: "77777777")
//                    //let userdata = try await UserManager.shared.readUserData(userId: "77777777")
//                    print(userdata.name)
//                } catch {
//                    print("ERROR: \(error.localizedDescription)")
//                }
//            }
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
        }
//        .onAppear {
//            let authenticatedUser = try? AuthManager.shared.getAuthenticatedUser()
//            showSignInView = authenticatedUser == nil
//        }
//        .fullScreenCover(isPresented: $showSignInView) {
//            SignInView()
//        }
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile(showSignInView: .constant(true))
    }
}
