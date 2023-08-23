//
//  BookWormApp.swift
//  BookWorm
//
//  Created by Anay Sahu on 7/30/23.
//

import SwiftUI

@main
struct BookWormApp: App {
    @StateObject var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            BookWormView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
