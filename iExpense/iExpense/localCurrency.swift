//
//  localCurrency.swift
//  iExpense
//
//  Created by Anay Sahu on 7/16/23.
//

import Foundation


extension FormatStyle where Self == FloatingPointFormatStyle<Double>.Currency {
    static var localCurrency: Self {
        .currency(code: Locale.current.currency?.identifier ?? "USD")
    }
}
