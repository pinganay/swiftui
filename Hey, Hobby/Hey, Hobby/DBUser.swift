//
//  User.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 9/17/23.
//

import Foundation

struct DBUser: Codable, Hashable, Equatable {
    var id: String
    var firstName: String
    var lastName: String
    var friendsId = [String]()
    var phoneNumber: String
    var emailAddress: String
    var recievedMessages = [String]()
    var statusHistory = [String]()
    
    static func ==(lhs: DBUser, rhs: DBUser) -> Bool {
        return lhs.id == rhs.id
    }
    
    static let sampleUser = DBUser(id: "Dummy", firstName: "Dummy", lastName: "Dummy", phoneNumber: "1234567890", emailAddress: "test@abc.com")
}
