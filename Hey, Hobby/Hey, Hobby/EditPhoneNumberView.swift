//
//  EditPhoneNumberView.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 12/21/23.
//

import SwiftUI

@MainActor final class EditPhoneNumberViewModel: ObservableObject {
    @Published var phoneNumber = ""
    @Published var isPhoneNumberValid = false
    func currentUser() async -> DBUser? {
        do {
            let user = try AuthManager.shared.getAuthenticatedUser()
            let userData = try await UserManager.shared.readUserData(userId: user.uid)
            
            return DBUser(id: userData.id, firstName: userData.firstName, lastName: userData.lastName, phoneNumber: phoneNumber)
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    func saveUser() async {
        do {
            guard let currentUser = await currentUser() else {
                print("There was a problem loading current user")
                return
            }
            
            try await UserManager.shared.writeUserData(user: currentUser)
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct EditPhoneNumberView: View {
    @StateObject var vm = EditPhoneNumberViewModel()
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userProfileVM: UserProfileViewModel
    
    var body: some View {
        VStack {
            Text(vm.isPhoneNumberValid ? "" : "Your phone number should have 8-13 digits and cannot be empty or contain any space")
                .foregroundColor(.red)
                .font(.caption)
            
            TextField("Enter your new phone number", text: $vm.phoneNumber)
                .padding()
                .background(.gray.opacity(0.4))
                .cornerRadius(10)
                .keyboardType(.numberPad)
            
            Button("Save") {
                Task {
                    await vm.saveUser()
                    userProfileVM.loggedInUser.phoneNumber = vm.phoneNumber
                    dismiss()
                }
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(height: 55)
            .frame(width: 200)
            .background(!vm.isPhoneNumberValid ? .gray : .accentColor)
            .cornerRadius(10)
            .disabled(!vm.isPhoneNumberValid)
        }
        .onChange(of: vm.phoneNumber) { _ in
            if !vm.phoneNumber.isPhoneNumberLengthValid || !vm.phoneNumber.isInt || vm.phoneNumber.isEmpty {
                vm.isPhoneNumberValid = false
            } else {
                vm.isPhoneNumberValid = true
                print("Phone number should have 8-13 digits")
            }
        }
    }
}

struct EditPhoneNumberView_Previews: PreviewProvider {
    static var previews: some View {
        EditPhoneNumberView()
    }
}
