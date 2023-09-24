//
//  BiometricsView.swift
//  BucketList
//
//  Created by Anay Sahu on 9/3/23.
//

import LocalAuthentication
import SwiftUI

struct BiometricsView: View {
    @State private var isAuthenticated = false
    
    var body: some View {
        Text(isAuthenticated ? "Unlocked" : "Locked")
            .onAppear(perform: authenticate)
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "We need to use your data") { success, authenticationError in
                if success {
                    isAuthenticated = true
                } else {
                    print("Error with FaceID")
                    isAuthenticated = false
                }
            }
        } else {
            print("Your Device does not support FaceID")
        }
    }
}

struct BiometricsView_Previews: PreviewProvider {
    static var previews: some View {
        BiometricsView()
    }
}
