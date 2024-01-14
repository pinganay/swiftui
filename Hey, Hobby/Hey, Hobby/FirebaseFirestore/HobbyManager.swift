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

    func readHobbyList() async throws -> Set<String> {
        let hobbyList = try await hobbyCollection.document("hobbyDocument").getDocument(as: HobbyList.self)
        // We change the array to set because we don't want duplicates
        // Also it is faster to search for items in a set
        let hobbySet = Set(hobbyList.hobbies)
        return hobbySet
    }
    
    func writeToHobbyList(hobbyList: [String]) async throws {
        //try hobbyCollection.document("hobbyDocument").setData(from: hobbyList)
        try await hobbyCollection.document("hobbyDocument").updateData([
            "hobbies" : FieldValue.arrayUnion(hobbyList)
            ])
    }
}
