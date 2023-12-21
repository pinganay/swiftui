//
//  UserDetailsView.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 9/25/23.
//

import SwiftUI

final class UserDetailsViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var phoneNumber = ""
    @Published var isFirstNameValid = false
    @Published var isLastNameValid = false
    @Published var isPhoneNumberValid = false
    
    func saveUser() {
        Task {
            do {
                let authenticatedUser = try AuthManager.shared.getAuthenticatedUser()
                try await UserManager.shared.writeUserData(user: DBUser(id: authenticatedUser.uid, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber))
            } catch {
                print("UserDetailsViewModel: Error \(error.localizedDescription)")
            }
        }
    }
}

struct UserDetailsView: View {
    @StateObject var viewModel = UserDetailsViewModel()
    @Environment(\.dismiss) var dismiss
    @Binding var showUserProfile: Bool
    @Binding var showUserDetails: Bool
    @Binding var showSignInView: Bool
    @Binding var showWelcomeView: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                Section {
                    Text(viewModel.isFirstNameValid ? "" : "You first name cannot be empty or contain any space")
                        .foregroundColor(.red)
                        .font(.caption)
                    
                    TextField("First Name...", text: $viewModel.firstName)
                        .padding()
                        .background(.gray.opacity(0.4))
                        .cornerRadius(10)
                        .onChange(of: viewModel.firstName) { _ in
                            if viewModel.firstName.containsWhitespace || viewModel.firstName.isEmpty {
                                viewModel.isFirstNameValid = false
                            } else {
                                viewModel.isFirstNameValid = true
                            }
                        }
                }
                
                Section {
                    Text(viewModel.isLastNameValid ? "" : "You last name cannot be empty or contain any space")
                        .foregroundColor(.red)
                        .font(.caption)
                    
                    TextField("Last Name...", text: $viewModel.lastName)
                        .padding()
                        .background(.gray.opacity(0.4))
                        .cornerRadius(10)
                        .onChange(of: viewModel.lastName) { _ in
                            if viewModel.lastName.containsWhitespace || viewModel.lastName.isEmpty {
                                viewModel.isLastNameValid = false
                            } else {
                                viewModel.isLastNameValid = true
                            }
                        }
                }
                
                Section {
                    Text(viewModel.isPhoneNumberValid ? "" : "Your phone number should have 8-13 digits and cannot be empty or contain any space")
                        .foregroundColor(.red)
                        .font(.caption)
                    
                    TextField("Phone Number...", text: $viewModel.phoneNumber)
                        .padding()
                        .background(.gray.opacity(0.4))
                        .cornerRadius(10)
                        .onChange(of: viewModel.phoneNumber) { _ in
                            if !viewModel.phoneNumber.isPhoneNumberLengthValid || !viewModel.phoneNumber.isInt || viewModel.phoneNumber.containsWhitespace || viewModel.phoneNumber.isEmpty {
                                viewModel.isPhoneNumberValid = false
                            } else {
                                viewModel.isPhoneNumberValid = true
                                print("Phone number should have 8-13 digits")
                            }
                        }
                }
                
                Button("Save") {
                    viewModel.isFirstNameValid = true
                    viewModel.isLastNameValid = true
                    viewModel.isPhoneNumberValid = true
                    viewModel.saveUser()
                    showWelcomeView = true
                    showUserDetails = false
                    showSignInView = false
                    showUserProfile = false
                    dismiss()
                }
                .disabled(!viewModel.isFirstNameValid || !viewModel.isLastNameValid || !viewModel.isPhoneNumberValid)
            }
            .padding()
            
            .navigationTitle("Enter your Name")
        }
    }
}

struct UserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailsView(showUserProfile: .constant(true), showUserDetails: .constant(false), showSignInView: .constant(false), showWelcomeView: .constant(false))
    }
}
