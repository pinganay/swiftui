//
//  FriendFaceApp.swift
//  FriendFace
//
//  Created by Anay Sahu on 8/23/23.
//

import SwiftUI

@main
struct FriendFaceApp: App {
    @StateObject var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
