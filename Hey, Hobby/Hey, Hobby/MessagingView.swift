//
//  MessagingView.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 10/14/23.
//

import SwiftUI
import Combine

struct MessagingView: View {
    @EnvironmentObject var vm: UserProfileViewModel
    @EnvironmentObject var delegate: AppDelegate
    
    var body: some View {
        VStack {
            Section {
                HStack {
//                    Text("Set your Status")
//                        .padding(.trailing, 5)
//                        //.font(.largeTitle)
                    
                    TextField("Enter your status", text: $vm.userMessage)
                        .font(.headline)
                        .padding()
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(.gray.opacity(0.4))
                        .cornerRadius(10)
                        .onChange(of: vm.userMessage) { message in
                            vm.validateUserString(message)
                            if message.count >= 3 {
                                vm.filteredHobbies = vm.hobbyList.filter { hobby in
                                    hobby.lowercased().contains(message.lowercased())
                                }
                            } else {
                                vm.filteredHobbies = []
                            }
                        }
                        .padding()
                    
                    Button("Set Status") {
                        Task {
                            let loggedInUser = await vm.getLoggedInUser()
                            let loggedInUserFullName = "\(loggedInUser.firstName) \(loggedInUser.lastName)"
                            vm.statusHistory.append(vm.userMessage)
                            UserManager.shared.updateStatusHistory(forCurrentUserId: loggedInUser.id, statusHistory: vm.statusHistory)
                            vm.addMessage(message: vm.userMessage, userId: loggedInUser.id, currentUserName: loggedInUserFullName)
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 100 ,height: 50)
                    //.frame(maxWidth: .infinity)
                    .background(vm.buttonColor)
                    .cornerRadius(10)
                    .padding()
                    .disabled(vm.disableSendButton)
                }
                
                HStack(spacing: 50) {
                    Text(vm.filteredHobbies.count > 0 ? "Did you mean: " : "")
                }
                
                ForEach(vm.filteredHobbies, id: \.self) { filteredHobby in
                    Button(filteredHobby) {
                        vm.userMessage = filteredHobby
                    }
                }
                
//                Button("Send Message") {
//                    Task {
//                        let loggedInUser = await vm.getLoggedInUser()
//                        let loggedInUserFullName = "\(loggedInUser.firstName) \(loggedInUser.lastName)"
//                        vm.addMessage(message: vm.userMessage, userId: loggedInUser.id, currentUserName: loggedInUserFullName)
//                    }
//                }
//                .font(.headline)
//                .foregroundColor(.white)
//                .frame(height: 55)
//                .frame(maxWidth: .infinity)
//                .background(vm.buttonColor)
//                .cornerRadius(10)
//                .padding(.horizontal, 130)
//                .disabled(vm.disableSendButton)
            }
            
            Seperator(width: 400)
            
            
            Text("My Status History")
                .padding(.trailing, 5)
                .font(.largeTitle)
            
            List(vm.statusHistory, id: \.self) { status in
                Text(status)
            }
            
            Seperator(width: 400)
            
            Text("My Friends' Status History")
                .padding(.trailing, 5)
                .font(.largeTitle)
            
            List(delegate.recievedMessages, id: \.self) { recievedStatus in
                Text(recievedStatus)
            }
        }
        .task {
            await vm.loadHobbiesFromDB()
            do {
                let authenticatedUser = try AuthManager.shared.getAuthenticatedUser()
                let currentUser = try await UserManager.shared.readUserData(userId: authenticatedUser.uid)
                vm.statusHistory = currentUser.statusHistory
                delegate.recievedMessages = currentUser.recievedMessages
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct MessagingView_Previews: PreviewProvider {
    static var previews: some View {
        MessagingView()
    }
}
