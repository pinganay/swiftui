//
//  MessagingView.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 10/14/23.
//

import SwiftUI

struct MessagingView: View {
    @EnvironmentObject var vm: UserProfileViewModel
    
    var body: some View {
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
        .background(.blue)
        .cornerRadius(10)
        .padding(.horizontal, 130)
        
        Seperator(width: 400)
//
//        Text("Recieved Messages")
//            .padding(.trailing, 5)
//            .font(.largeTitle)
//
//        List(vm.messageList, id: \.self) { message in
//            Text(message)
//        }
//
//        Seperator(width: 400)
        
        Text("Sent Messages")
            .padding(.trailing, 5)
            .font(.largeTitle)
        
        List(vm.messageList, id: \.self) { message in
            Text(message)
        }
        
        Spacer()
    }
}

struct MessagingView_Previews: PreviewProvider {
    static var previews: some View {
        MessagingView()
    }
}
