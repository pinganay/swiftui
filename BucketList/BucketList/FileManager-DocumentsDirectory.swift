//
//  FileManager-DocumentsDirectory.swift
//  BucketList
//
//  Created by Anay Sahu on 9/9/23.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
