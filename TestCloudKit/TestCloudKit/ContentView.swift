//
//  ContentView.swift
//  TestCloudKit
//
//  Created by Anay Sahu on 10/4/23.
//

import SwiftUI
import CloudKit

class ContentViewModel: ObservableObject {
    func requestiCloudPermission() {
        CKContainer.default().requestApplicationPermission([.userDiscoverability]) { status, error in
            DispatchQueue.main.async {
                if status == .granted {
                    print("requestiCloudPermission Status: true")
                    print("requestiCloudPermission Error: \(String(describing: error))")
                } else {
                    print("requestiCloudPermission Status: false")
                    print("requestiCloudPermission Error: \(String(describing: error))")
                }
            }
        }
    }
}

struct ContentView: View {
    @StateObject var vm = ContentViewModel()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .onAppear(perform: vm.requestiCloudPermission)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
