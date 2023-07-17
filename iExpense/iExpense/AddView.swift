//
//  AddView.swift
//  iExpense
//
//  Created by Anay Sahu on 7/16/23.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var expenses: Expenses
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    let types = ["Bussiness", "Personal"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Task Name", text: $name)
                
                Picker("Select type", selection: $type) {
                    ForEach(types, id: \.self) { type in
                        Text(type)
                    }
                }
                TextField("Select type", value: $amount, format: .localCurrency)
                    .keyboardType(.numberPad)
                
            }
            .navigationTitle("Add expense")
            .toolbar {
                Button("Save") {
                    let expenseItem = ExpenseItem(name: name, type: type, amount: amount)
                    expenses.items.append(expenseItem)
                    saveUserData(expenses: expenses)
                    dismiss()
                }
            }
        }
    }
    
    func saveUserData(expenses: Expenses) {
        let encoder = JSONEncoder()
        
        if let data = try? encoder.encode(expenses.items) {
            UserDefaults.standard.set(data, forKey: "ExpenseItems")
            print("Reading Data \(data)")
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
