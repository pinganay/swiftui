//
//  onDeleteView.swift
//  iExpense
//
//  Created by Anay Sahu on 7/15/23.
//

import SwiftUI

struct onDeleteView: View {
    @State private var numbers = [Int]()
    @State private var currentNumber = 0
    
    var body: some View {
        NavigationView {
            VStack{
                List {
                    ForEach(numbers, id: \.self) {
                        Text("Row \($0)")
                    }
                    .onDelete(perform: deleteRow)
                }
                Button("Add Row") {
                    numbers.append(currentNumber)
                    currentNumber += 1
                }
            }
            .navigationTitle("AddDeleteRows")
            .toolbar {
                EditButton()
            }
        }
    }
    
    func deleteRow(at offset: IndexSet) {
        numbers.remove(atOffsets: offset)
    }
}

struct onDeleteView_Previews: PreviewProvider {
    static var previews: some View {
        onDeleteView()
    }
}
