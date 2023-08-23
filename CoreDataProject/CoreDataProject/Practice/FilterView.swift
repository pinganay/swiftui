//
//  FilterView.swift
//  CoreDataProject
//
//  Created by Anay Sahu on 8/15/23.
//

import SwiftUI

struct FilterView: View {
    
    @Environment(\.managedObjectContext) var moc
    @State private var lastNameFilter = "A"
    
    var body: some View {
        VStack {
            FilteredListView(filter: lastNameFilter, predicate: "CONTAINS[C]")
            
            Button("Add Singers") {
                let taylor = Singers(context: moc)
                taylor.fName = "Taylor"
                taylor.lName = "Swift"

                let ed = Singers(context: moc)
                ed.fName = "Ed"
                ed.lName = "Sheeran"

                let adele = Singers(context: moc)
                adele.fName = "Adele"
                adele.lName = "Adkins"
                
                let badele = Singers(context: moc)
                badele.fName = "Adele"
                badele.lName = "Badkins"
                
                try? moc.save()
            }
            
            Button("Show A") {
                lastNameFilter = "A"
            }

            Button("Show S") {
                lastNameFilter = "S"
            }
            
            
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
    }
}
