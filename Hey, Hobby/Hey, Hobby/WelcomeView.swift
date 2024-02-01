//
//  WelcomeView.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 10/12/23.
//

import SwiftUI

//@MainActor class WelcomeViewModel: ObservableObject {
//    var showTermsOfService = false
//}

struct WelcomeView: View {
    @EnvironmentObject var vm: UserProfileViewModel
//    @StateObject var welcomeVM = WelcomeViewModel()
    @State var currentUser = DBUser.sampleUser
//    @State private var loadFriendsListFromDB = true
//    @Environment(\.dismiss) var dismiss
    @Binding var showSignInView: Bool
    @Binding var showUserProfile: Bool
    @Binding var showUserDetails: Bool
    @Binding var showWelcomeView: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                //If loading the user info takes too long, this displays the loading view
                if currentUser.firstName == "Dummy" {
                    LoadingView()
                } else {
                    Text("Hey, \(currentUser.firstName) \(currentUser.lastName)")
                        .foregroundColor(.white)
                        .font(.titleScript)
                }
                
                Spacer()
                
                HStack {
                    NavigationLink {
                        UserProfile(showSignInView: $showSignInView)
                    } label: {
                        VStack(alignment: .center) {
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding([.top])
                            
                            Text("Profile")
                                .font(.system(size: 16.5))
                                .bold()
                        }
//                        .padding(.leading)
                    }
                    
                    Spacer()
                    
                    NavigationLink {
                        MessagingView()
                    } label: {
                        VStack(alignment: .center) {
                            Image(systemName: "message.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding([.top])
                            
                            Text("Status")
                                .font(.system(size: 16.5))
                                .bold()
                        }
//                        .padding(.leading)
                    }
                    
                    Spacer()
                    
                    NavigationLink {
                        AddFriendView()
                    } label: {
                        VStack {
                            Image(systemName: "person.3.fill")
                                .resizable()
                                .frame(width: 54, height: 30)
                                .padding([.top])
                            
                            Text("Friend")
                                .font(.system(size: 16.5))
                                .bold()
                        }
                    }
//                    .padding(.trailing)
                    
                    Spacer()
                    
                    NavigationLink {
                        InfoView()
                    } label: {
                        VStack {
                            Image(systemName: "info.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding([.top])
                            
                            Text("About")
                                .font(.system(size: 16.5))
                                .bold()
                        }
                    }
                }
                .padding([.trailing, .leading])
                .background(.gray.opacity(0.35))
            }
            //.navigationTitle("Hey, Hobby!")
            // Use toolbar instead of .navigationTitle, so that font can be customized
            .toolbar {
//                ToolbarItem {
//                    NavigationLink {
//                        InfoView()
//                    } label: {
//                        Image(systemName: "info.circle.fill")
//                            .background(.red)
//                    }
//                }
                
                ToolbarItem(placement: .principal) { // <3>
                    VStack {
                        Text("Hey, Hobby!")
                            .foregroundColor(.white)
                            .font(.titleScript)
                    }
                }
                
                ToolbarItem {
                    Button("Log Out") {
                        vm.signOut()
                        print("Succesfully Logged out User")
                        showSignInView = true
                    }
                    .buttonModifier(width: 80)
                }
            }
            .background(.themeColor)
//            .toolbar {
//                ToolbarItem {
//                    Button("Log Out") {
//                        vm.signOut()
//                        print("Succesfully Logged out User")
//                        showSignInView = true
//                    }
//                    .buttonModifier(width: 80)
//                }
//            }
            .fullScreenCover(isPresented: $showSignInView) {
                SignInView()
            }
        }
        .onAppear {
//            for family in UIFont.familyNames.sorted() {
//                let names = UIFont.fontNames(forFamilyName: family)
//                print("Family: \(family) Font names: \(names)")
//            }
            
            vm.requestNotificationPermissions()
            //welcomeVM.showTermsOfService = true
        }
        .task {
            let authenticatedUser = try? AuthManager.shared.getAuthenticatedUser()
            showUserProfile = authenticatedUser != nil
            showSignInView = !showUserProfile
            showUserDetails = false
            
            currentUser = await vm.readCurrentUser()
            
            //should be called once
            if vm.loadFriendsListFromDB {
                vm.loadCurrentUserFriendsList(userIdList: currentUser.friendsId)
                vm.loadFriendsListFromDB = false
            }
        }
//        .sheet(isPresented: $welcomeVM.showTermsOfService) {
//            HStack {
//                Spacer()
//
//                VStack {
//                    Text("Terms Of Service")
//                        .font(.titleScriptSmall)
//
//                    Spacer(minLength: 100)
//
//                    ScrollView {
//                        Text("Hello World  Hello World 2 Hello World  Hello World 2 Hello World  Hello World 2 Hello World  Hello World 2 Hello World  Hello World 2 Hello World  Hello World 2 Hello World  Hello World 2 Hello World  Hello World 2Hello World  Hello World 2 Hello World  Hello World 2 Hello World  Hello World 2 Hello World  Hello World 2 Hello World  Hello World 2 Hello World  Hello World 2 Hello World  Hello World 2 Hello World  Hello World 2 Hello World  Hello World 2 Hello World  Hello World 2 Hello World  Hello World 2 Hello World  Hello World 2")
//                    }
//
//                    Button("Accept") {
//                        dismiss()
//                    }
//                }
//                .interactiveDismissDisabled()
//
//                Spacer()
//            }
//            .background(.themeColor)
//        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(showSignInView: .constant(false), showUserProfile: .constant(false), showUserDetails: .constant(false), showWelcomeView: .constant(false))
    }
}
