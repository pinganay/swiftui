//
//  CachedUserData+CoreDataProperties.swift
//  FriendFace
//
//  Created by Anay Sahu on 8/27/23.
//
//

import Foundation
import CoreData


extension CachedUserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedUserData> {
        return NSFetchRequest<CachedUserData>(entityName: "CachedUserData")
    }

    @NSManaged public var about: String?
    @NSManaged public var address: String?
    @NSManaged public var age: Int16
    @NSManaged public var company: String?
    @NSManaged public var email: String?
    @NSManaged public var id: String?
    @NSManaged public var isActive: Bool
    @NSManaged public var name: String?
    @NSManaged public var registered: Date?
    @NSManaged public var tags: String?
    @NSManaged public var friends: CachedFriend?
    
    @objc(addFriendsObject:)
    @NSManaged public func addToFriends(_ value: CachedFriend)

    var wrappedId: String {
        id ?? ""
    }
    
    var wrappedName: String {
        name ?? ""
    }
    
    var wrappedAddress: String {
        address ?? ""
    }
    
    var wrappedCompany: String {
        company ?? ""
    }
    
    var wrappedRegistered: Date {
        registered ?? Date.now
    }
    
    var wrappedAbout: String {
        about ?? ""
    }
    
    var wrappedEmail: String {
        email ?? ""
    }
    
    var wrappedTags: String {
        tags ?? ""
    }
    
    var friendsArray: [CachedFriend] {
        let set = friends as? Set<CachedFriend> ?? []
        
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }

}

extension CachedUserData : Identifiable {

}
