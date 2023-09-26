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

struct DBUser: Codable {
    var id: String
    var firstName: String
    var lastName: String
//    var hobbies: [Hobby]
//
//    var hobbyList: [String] {
//        var list = [String]()
//
//        for hobby in hobbies {
//            list.append(hobby.rawValue)
//        }
//
//        return list
//    }
    
    static let sampleUser = DBUser(id: "000000000", firstName: "Bob", lastName: "Someone")
    //static let sampleUserList = [DBUser(id: "000000000", name: "Billie", hobbies: [.Chess, .Cricket, .Soccer]), DBUser(id: "76787687", name: "Sri", hobbies: [.Chess, .Soccer]), DBUser(id: "56378768786", name: "Subhang", hobbies: [.Chess, .Cricket])]
}

struct Community {
    var id: String
    let name: String
    var members: [DBUser]
    
    //static let sampleCommunities = [Community(id: "00", name: "TheChessChampions", members: DBUser.sampleUserList), Community(id: "232312312341", name: "WeLikeChess", members: DBUser.sampleUserList)]
}
