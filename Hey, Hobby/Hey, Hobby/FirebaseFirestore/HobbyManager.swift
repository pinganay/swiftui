//
//  HobbyManager.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 12/18/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct HobbyList: Codable {
    var hobbies = [String]()
}

final class HobbyManager {
    static var shared = HobbyManager()
    
    let hobbyCollection = Firestore.firestore().collection("hobbyList")
    
    private init() {}
    
    func readHobbyList() async throws -> [String] {
        let hobbyList = try await hobbyCollection.document("hobbyDocument").getDocument(as: HobbyList.self)
        return hobbyList.hobbies
    }
    
    func writeToHobbyList(hobbyList: [String]) async throws {
        try hobbyCollection.document("hobbyDocument").setData(from: hobbyList)
    }
}
