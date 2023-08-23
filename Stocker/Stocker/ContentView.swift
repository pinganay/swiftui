//
//  ContentView.swift
//  Stocker
//
//  Created by Anay Sahu on 8/1/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var stockList = StocksList()
    @State private var showAddStock = false
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(stockList.stocks) { stock in
                    HStack {
                        Text(stock.stockSymbol)
                            .font(.title2.bold())
                        
                        Spacer()
                        
                        VStack {
                            Text("\(stock.currentPrice.formatted(.currency(code: "USD")))")
                                .font(.title3.bold())
                            Text("\(stock.paidPrice.formatted(.currency(code: "USD")))")
                        }
                        
                        if stock.gainOrLoss > 0 {
                            Text("\(stock.gainOrLoss.formatted(.currency(code: "USD")))")
                                .foregroundColor(.green)
                            Text(stock.percentageGainOrLoss.formatted())
                                .foregroundColor(.green)
                        } else if stock.gainOrLoss < 0 {
                            Text("\(stock.gainOrLoss.formatted(.currency(code: "USD")))")
                                .foregroundColor(.red)
                            Text(stock.percentageGainOrLoss.formatted())
                                .foregroundColor(.red)
                        } else {
                            Text("\(stock.gainOrLoss.formatted(.currency(code: "USD")))")
                                .foregroundColor(.gray)
                            Text(stock.percentageGainOrLoss.formatted())
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Stocker")
            .sheet(isPresented: $showAddStock) {
                AddStockView(stockList: stockList)
            }
            .toolbar {
                Button {
                    showAddStock = true
                } label: {
                    Image(systemName: "plus")
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
