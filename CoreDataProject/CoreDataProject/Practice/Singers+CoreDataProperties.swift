//
//  Singers+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by Anay Sahu on 8/15/23.
//
//

import Foundation
import CoreData


extension Singers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Singers> {
        return NSFetchRequest<Singers>(entityName: "Singers")
    }

    @NSManaged public var fName: String?
    @NSManaged public var lName: String?

    var wrappedFName: String {
        fName ?? "Unknown"
    }
    
    var wrappedLName: String {
        lName ?? "Unknown"
    }
}

extension Singers : Identifiable {

}
