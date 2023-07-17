//
//  Expenses.swift
//  iExpense
//
//  Created by Anay Sahu on 7/16/23.
//

import Foundation


class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]()
}
