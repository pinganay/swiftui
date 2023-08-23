//
//  FilteredListView.swift
//  CoreDataProject
//
//  Created by Anay Sahu on 8/15/23.
//

import SwiftUI

struct FilteredListView: View {
    @FetchRequest var fetchRequest: FetchedResults<Singers>
    
    var body: some View {
        List(fetchRequest, id: \.self) { singer in
            Text("\(singer.wrappedFName) \(singer.wrappedLName)")
        }
    }
    
    init(filter: String, predicate: String) {
        _fetchRequest = FetchRequest<Singers>(sortDescriptors: [SortDescriptor(\.lName), SortDescriptor(\.lName)], predicate: NSPredicate(format: "lName \(predicate) %@", filter))
    }
}

