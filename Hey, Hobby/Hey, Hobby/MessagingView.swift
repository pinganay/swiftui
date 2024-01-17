//
//  MessagingView.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 10/14/23.
//

import SwiftUI
import Combine

class MessagingViewModel: AppDelegate {
    @EnvironmentObject var userProfileVM: UserProfileViewModel
    @EnvironmentObject var delegate: AppDelegate
    
    enum StatusCategory {
        case sent, recieved
    }
    
    func deleteOldRecievedStatus(forStatusCategory statusCategory: StatusCategory, messageList: [String]) {
        var expiredmessages = [String]()
        var index = messageList.count - 1
        
        while index >= 0 {
            let statusSubstrings = messageList[index].components(separatedBy: " -")
            let statusDateString = statusSubstrings[0]
            
            print(statusDateString)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy:HH:mm a"
            
            guard let statusDate = dateFormatter.date(from: statusDateString) else {
                print("deleteOldRecievedStatus() error: Failed to get Date object from recieved status")
                return
            }
            
            guard let daysDiff = Calendar.current.dateComponents([.day], from: statusDate, to: Date()).day else {
                print("deleteOldRecievedStatus() error: Cannot find difference between days")
                return
            }
            
            //This will mark a recieved status to be deleted if it is more than 2 days old
            if daysDiff >= 2 {
                expiredmessages.append(messageList[index])
            }
            
            index -= 1
        }
        
        print(expiredmessages)
        
        do {
            let currentUser = try AuthManager.shared.getAuthenticatedUser()
            
            if statusCategory == .recieved {
                UserManager.shared.deleteRecievedMessages(forCurrentUserId: currentUser.uid, recievedMessages: expiredmessages)
            } else {
                UserManager.shared.deleteStatusHistory(forCurrentUserId: currentUser.uid, statusHistory: expiredmessages)
            }
        } catch {
            print("deleteOldRecievedStatus() error: \(error.localizedDescription)")
        }
    }
}

struct MessagingView: View {
    @EnvironmentObject var vm: UserProfileViewModel
    @EnvironmentObject var delegate: AppDelegate
    @StateObject var messagingVM = MessagingViewModel()
    
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
                            
                            let date = Date().formatted(date: .numeric, time: .omitted)
                            let time = Date().formatted(date: .omitted, time: .shortened)
                            
                            vm.statusHistory.append("\(date):\(time) -> \(vm.userMessage)")
                            UserManager.shared.addStatusHistory(forCurrentUserId: loggedInUser.id, statusHistory: vm.statusHistory)
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
                
                /*
                 This loads the status history of the current user from db
                 Also, the status history is then stored in the viewModel to update the UI as soon as the MessagingView is shown
                 */
                vm.statusHistory = currentUser.statusHistory
                /*
                 This loads the list of recieved status of the current user from db
                 Also, the list of recieved status is then stored in the delegate to update the UI as soon as the MessagingView is shown
                 */
                
                //The timer will call the deleteOldRecievedStatus function every 3 hours
                Timer.scheduledTimer(withTimeInterval: 3600 * 3, repeats: true) { timer in
                //Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
                    print("timer called")
                    messagingVM.deleteOldRecievedStatus(forStatusCategory: .recieved, messageList: currentUser.recievedMessages)
                    messagingVM.deleteOldRecievedStatus(forStatusCategory: .sent, messageList: currentUser.statusHistory)
                }
                
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
