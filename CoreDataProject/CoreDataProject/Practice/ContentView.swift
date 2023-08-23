//
//  ContentView.swift
//  CoreDataProject
//
//  Created by Anay Sahu on 8/12/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var wizards: FetchedResults<Wizard>
    @State private var cnt = 0
    
    var body: some View {
        VStack {
            List {
                ForEach(wizards, id: \.self) { wizard in
                    Text("\(wizard.name ?? "Unkown") \(wizard.age)")
                }
            }
            Button("Add") {
                cnt += 1
                let wizard = Wizard(context: moc)
                wizard.name = "Harry Potter"
                wizard.age = Int16(cnt)
            }
            Button("Save") {
                do {
                    try moc.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
