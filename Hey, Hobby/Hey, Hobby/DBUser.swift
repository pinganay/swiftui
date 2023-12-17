//
//  User.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 9/17/23.
//

import Foundation

enum Hobby: String, Codable {
    case Soccer = "Soccer"
    case Cricket = "Cricket"
    case Chess = "Chess"
    case Painting = "Painting"
}

struct DBUser: Codable, Hashable, Equatable {
    var id: String
    var firstName: String
    var lastName: String
    var friendsId = [String]()
    var phoneNumber: String
    
    static func ==(lhs: DBUser, rhs: DBUser) -> Bool {
        return lhs.id == rhs.id
    }
    
    static let sampleUser = DBUser(id: "Dummy", firstName: "Dummy", lastName: "Dummy", phoneNumber: "1234567890")
}

struct Community {
    var id: String
    let name: String
    var members: [DBUser]
}
