//
//  DataController.swift
//  BookWorm
//
//  Created by Anay Sahu on 7/30/23.
//

import CoreData
import Foundation


class DataController: ObservableObject {
    var container = NSPersistentContainer(name: "CoreDataProject")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Failed to load CoreData: \(error.localizedDescription)")
                return
            }
            
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
}
