//
//  ContentView.swift
//  iExpense
//
//  Created by Anay Sahu on 7/15/23.
//

import SwiftUI

class User: ObservableObject {
    @Published var firstName = "Bilbo"
    @Published var lastName = "Frodo"
}

struct SecondView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Text("Hello World")
        Button("Close") {
            dismiss()
        }
    }
}

struct ContentView: View {
    @StateObject private var user = User()
    @State private var showSheet = false
    
    var body: some View {
//        VStack {
//            Text("Your name is \(user.firstName) \(user.lastName)")
//
//            TextField("First Name", text: $user.firstName)
//            TextField("Last Name", text: $user.lastName)
//        }
//        .padding()
        Button("Tap Me") {
            showSheet.toggle()
        }
        .sheet(isPresented: $showSheet) {
            SecondView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
