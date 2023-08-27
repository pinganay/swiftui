//
//  User.swift
//  FriendFace
//
//  Created by Anay Sahu on 8/23/23.
//

import Foundation

struct UserData: Codable {
    let id: String
    let isActive: Bool
    let name: String
    let age: Int
    let company: String
    let email: String
    let address: String
    let about: String
    let registered: Date
    let tags: [String]
    let friends: [Friends]
}

