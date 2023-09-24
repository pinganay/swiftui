//
//  WritingToDocumentsDirectoryView.swift
//  BucketList
//
//  Created by Anay Sahu on 9/1/23.
//

import SwiftUI

struct WritingToDocumentsDirectoryView: View {
    var body: some View {
        Text("Hello")
            .onTapGesture {
                let str = "Test Message"
                let url = getDocumentsDirectory().appendingPathComponent("message.txt")
                
                do {
                    try str.write(to: url, atomically: true, encoding: .utf8)
                    let input = try String(contentsOf: url)
                    print(input)
                } catch {
                    print(error.localizedDescription)
                }
            }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
}

struct WritingToDocumentsDirectoryView_Previews: PreviewProvider {
    static var previews: some View {
        WritingToDocumentsDirectoryView()
    }
}
