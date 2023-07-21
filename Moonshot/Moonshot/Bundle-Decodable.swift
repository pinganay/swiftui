//
//  Bundle-Decodable.swift
//  Moonshot
//
//  Created by Anay Sahu on 7/18/23.
//

import Foundation

extension Bundle {
    func decode<T: Codable>(_ file: String) -> T {
        guard let url = Bundle.main.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file)")
        }
        
        guard let fileContents = try? Data(contentsOf: url) else {
            fatalError("Failed to read data from \(file)")
        }
        
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        guard let loaded = try? decoder.decode(T.self, from: fileContents) else {
            fatalError("Failed to decode data from \(file)")
        }
        
        return loaded
    }
}
