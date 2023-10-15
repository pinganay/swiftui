//
//  Hey__HobbyApp.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 9/17/23.
//

import SwiftUI
import Firebase

@main
struct Hey__HobbyApp: App {
    
    @StateObject var vm = UserProfileViewModel()
    
    init() {
        FirebaseApp.configure()
        print("Configured Firebase succesfully")
    }
    
    var body: some Scene {
        WindowGroup {
            SignInView()
                .environmentObject(vm)
        }
    }
}
