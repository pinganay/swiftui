//
//  AddStockView.swift
//  Stocker
//
//  Created by Anay Sahu on 8/1/23.
//

import SwiftUI

struct AddStockView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var stockList: StocksList
    @State private var stockSymbol = ""
    @State private var pricePaid = ""
    
    var validPrice: Bool {
        if Double(pricePaid) == -1.0 {
            return false
        }
        return true
    }
    
    var body: some View {
        VStack {
            
            TextField("Stock Symbol", text: $stockSymbol)
                .padding(.horizontal)
            TextField("Paid Price", text: $pricePaid)
                .padding(.horizontal)
            Spacer()
            
            
//            VStack {
//                Text("Stock Symbol: \(stockSymbol)")
//                    .font(.title)
//                Text("$\(pricePaid)")
//            }
            
            
            Spacer()
            
            Button {
                let stock = Stock(stockSymbol: stockSymbol, currentPrice: 2.0, paidPrice: Double(pricePaid) ?? -1.0)
                stockList.stocks.append(stock)
                dismiss()
            } label: {
                Text("Add Stock")
            }
            .disabled(validPrice == false)

        }
        .padding()
        .navigationTitle("Add Stock")
    }
}

struct AddStockView_Previews: PreviewProvider {
    static var previews: some View {
        AddStockView(stockList: StocksList())
    }
}
