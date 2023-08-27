//
//  CachedFriend+CoreDataProperties.swift
//  FriendFace
//
//  Created by Anay Sahu on 8/27/23.
//
//

import Foundation
import CoreData


extension CachedFriend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedFriend> {
        return NSFetchRequest<CachedFriend>(entityName: "CachedFriend")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var user: CachedUserData?
    
    var wrappedName: String {
        name ?? ""
    }
}

extension CachedFriend : Identifiable {

}
