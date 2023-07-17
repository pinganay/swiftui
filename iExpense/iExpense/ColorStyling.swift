//
//  ColorStyling.swift
//  iExpense
//
//  Created by Anay Sahu on 7/16/23.
//

import SwiftUI

extension View {
    func style(for item: ExpenseItem) -> some View {
        if item.amount < 10 {
                return self.foregroundColor(.black)
        } else if item.amount < 100 {
                return self.foregroundColor(.yellow)
        } else {
                return self.foregroundColor(.red)
        }
    }
}
