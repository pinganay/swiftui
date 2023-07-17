//
//  iExpenseView.swift
//  iExpense
//
//  Created by Anay Sahu on 7/16/23.
//

import SwiftUI

struct iExpenseView: View {
    
    @StateObject var expenses = Expenses()
    @State private var showingAddView = false
   
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        
                        Spacer()
                        
                               
                        Text(item.amount, format: .localCurrency)
                            .style(for: item)
                    }
                }
                .onDelete(perform: removeObject)
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    showingAddView = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddView(expenses: expenses)
            }
            
            
        }
        .onAppear(perform: loadData)
    }
    
    func removeObject(at offset: IndexSet) {
        expenses.items.remove(atOffsets: offset)
    }
    
    func loadData() {
        let decoder = JSONDecoder()
        if let encodedData = UserDefaults.standard.data(forKey: "ExpenseItems") {
            print("Encodig dtat \(encodedData)")
            if let items = try? decoder.decode([ExpenseItem].self, from: encodedData) {
                print(items[0].name)
                expenses.items = items
            }
        }
    }
}

struct iExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        iExpenseView()
    }
}
