//
//  CoreDataProjectApp.swift
//  CoreDataProject
//
//  Created by Anay Sahu on 8/12/23.
//

import SwiftUI

@main
struct CoreDataProjectApp: App {
    @StateObject var dataCotroller = DataController()
    
    var body: some Scene {
        WindowGroup {
            FilterView()
                .environment(\.managedObjectContext, dataCotroller.container.viewContext)
        }
    }
}
