//
//  ContentView.swift
//  WeSplit
//
//  Created by Anay Sahu on 6/17/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var buttonCnt = 0
    @State private var name = ""
    let numList = [1,2,3,4,5]
    @State private var selectedNum = 1
    let employees = [0:"xyz", 1:"", 2:"Maria", 3:"Ted", 4:"Delia"]
        
    
    @State private var selectedEmployee = ""
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    
                    
                    Picker("Pick your number", selection: $selectedNum) {
                        ForEach(numList, id: \.self) { num in
                            Text(String(num))
                        }
                    }
                    
                    Text("You have selected \(selectedNum)")
                    
                    
                    Button("Button Count is: \(buttonCnt)") {
                        buttonCnt += 1
                    }
                    .background(alternateColor() ? Color.red : Color.white)
                    
                    
                    Text(buttonCnt == 11 ? "Yes" : "No")
                }
                
                
                TextField("Enter your name here", text: $name)
                Text("Your name is: \(name)")
                
                Picker("Select Your Employee", selection: $selectedEmployee) {
                    ForEach(Array(employees.keys), id: \.self) {
                        Text(employees[$0] ?? "N/A")
                    }
                }
                
            }
            .navigationTitle("SwiftUI")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    
    
    func alternateColor() -> Bool {
        buttonCnt.isMultiple(of: 2)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
