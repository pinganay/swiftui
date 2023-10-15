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
    
    func save() {
        Task {
            do {
                let authenticatedUser = try AuthManager.shared.getAuthenticatedUser()
                
                try await UserManager.shared.writeUserData(user: DBUser(id: authenticatedUser.uid, firstName: firstName, lastName: lastName))
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
        NavigationView {
            VStack {
                TextField("First Name...", text: $viewModel.firstName)
                    .padding()
                    .background(.gray.opacity(0.4))
                    .cornerRadius(10)
                TextField("Last Name...", text: $viewModel.lastName)
                    .padding()
                    .background(.gray.opacity(0.4))
                    .cornerRadius(10)
                
                Button("Save") {
                    viewModel.save()
                    showWelcomeView = true
                    showUserDetails = false
                    showSignInView = false
                    showUserProfile = false
                    dismiss()
                }
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
