//
//  Movie+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by Anay Sahu on 8/13/23.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var title: String?
    @NSManaged public var director: String?
    @NSManaged public var year: Int16
    
    public var wrappedTitle: String {
        title ?? "Unknown"
    }
    
    public var wrappedDirector: String {
        director ?? "Unknown"
    }

}

extension Movie : Identifiable {

}
