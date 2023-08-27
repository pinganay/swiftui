//
//  Users.swift
//  FriendFace
//
//  Created by Anay Sahu on 8/23/23.
//

import Foundation

class Users: ObservableObject, Codable {
    enum CodingKeys: CodingKey {
        case userList
    }

    
    //static let shared = Users(userList: [UserData(id: "Aa", isActive: true, name: "sf", age: 1, email: "ad", address: "d", about: "d", registered: "d", tags: ["dd"], friends: [Friends(name: "d", id: "sdfs")])])
    
    @Published var userList: [UserData] = []
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userList, forKey: .userList)
    }
    
    init() {}
    
    required init(from decoder: Decoder) {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        userList = try! container!.decode([UserData].self, forKey: .userList)
    }
}
