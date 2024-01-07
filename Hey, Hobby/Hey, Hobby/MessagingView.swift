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
                Text("Set your Status")
                    .padding(.trailing, 5)
                    .font(.largeTitle)
                
                TextField("Enter Message", text: $vm.userMessage)
                    .font(.headline)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.gray.opacity(0.4))
                    .cornerRadius(10)
                    .padding()
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
                
                HStack(spacing: 50) {
                    Text(vm.filteredHobbies.count > 0 ? "Did you mean: " : "")
                }
                ForEach(vm.filteredHobbies, id: \.self) { filteredHobby in
                    Button(filteredHobby) {
                        vm.userMessage = filteredHobby
                    }
                }
                
                Button("Send Message") {
                    Task {
                        let loggedInUser = await vm.getLoggedInUser()
                        let loggedInUserFullName = "\(loggedInUser.firstName) \(loggedInUser.lastName)"
                        vm.addMessage(message: vm.userMessage, userId: loggedInUser.id, currentUserName: loggedInUserFullName)
                    }
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(vm.buttonColor)
                .cornerRadius(10)
                .padding(.horizontal, 130)
                .disabled(vm.disableSendButton)
            }
            
            Seperator(width: 400)
            
            
            Text("Sent Messages")
                .padding(.trailing, 5)
                .font(.largeTitle)
            
            List(vm.messageList, id: \.self) { message in
                Text(message)
            }
            
            Seperator(width: 400)
            
            Text("Recieved Messages")
                .padding(.trailing, 5)
                .font(.largeTitle)
            
            List(delegate.recievedMessages, id: \.self) { message in
                Text(message)
            }
            
            Spacer()
        }
        .task {
            await vm.loadHobbiesFromDB()
            do {
                let authenticatedUser = try AuthManager.shared.getAuthenticatedUser()
                let currentUser = try await UserManager.shared.readUserData(userId: authenticatedUser.uid)
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
