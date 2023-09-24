//
//  Result.swift
//  BucketList
//
//  Created by Anay Sahu on 9/6/23.
//

import Foundation

struct Result: Codable {
    var query: Query
}

struct Query: Codable {
    var pages: [Int: Page]
}

struct Page: Codable, Comparable {
    var pageid: Int
    var title: String
    var terms: [String: [String]]?
    
    var description: String {
        terms?["description"]?.first ?? "No Description"
    }
    
    static func <(lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
}
