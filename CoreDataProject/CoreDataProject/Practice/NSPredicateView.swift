//
//  NSPredicateView.swift
//  CoreDataProject
//
//  Created by Anay Sahu on 8/15/23.
//

import SwiftUI

struct NSPredicateView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "name CONTAINS %@", "s")) var ships: FetchedResults<Ship>
    
    var body: some View {
        VStack {
            List(ships) { ship in
                Text(ship.name ?? "Unknown")
            }
            
            Button("Add Example") {
                let ship1 = Ship(context: moc)
                ship1.name = "Enterprise"
                ship1.universe = "Star Trek"
                
                let ship2 = Ship(context: moc)
                ship2.name = "Defiant"
                ship2.universe = "Star Trek"
                
                let ship3 = Ship(context: moc)
                ship3.name = "Millenium Falcon"
                ship3.universe = "Star Wars"
                
                let ship4 = Ship(context: moc)
                ship4.name = "Executor"
                ship4.universe = "Star Wars"
                
                try? moc.save()
            }
        }
    }
}

struct NSPredicateView_Previews: PreviewProvider {
    static var previews: some View {
        NSPredicateView()
    }
}
