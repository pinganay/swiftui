//
//  OneToManyView.swift
//  CoreDataProject
//
//  Created by Anay Sahu on 8/20/23.
//

import SwiftUI

struct OneToManyView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var countries: FetchedResults<Country>
    var body: some View {
        VStack {
            List {
                ForEach(countries, id: \.self) { country in
                    Section(country.wrappedFullName) {
                        ForEach(country.candyArray, id: \.self) { candy in
                            Text(candy.wrappedName)
                        }
                    }
                }
            }
            
            Button("Add") {
                let candy1 = Candy(context: moc)
                candy1.name = "Mars"
                candy1.origin = Country(context: moc)
                candy1.origin?.shortName = "UK"
                candy1.origin?.fullname = "United Kingdom"
                
                let candy2 = Candy(context: moc)
                candy2.name = "Toblerone"
                candy2.origin = Country(context: moc)
                candy2.origin?.shortName = "CH"
                candy2.origin?.fullname = "Switzerland"
            }
        }
    }
}

struct OneToManyView_Previews: PreviewProvider {
    static var previews: some View {
        OneToManyView()
    }
}
