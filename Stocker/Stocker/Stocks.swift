//
//  Stock.swift
//  Stocker
//
//  Created by Anay Sahu on 8/1/23.
//

import Foundation

//class Stock: ObservableObject, Identifiable, Codable {
//    enum CodingKeys: CodingKey {
//        case stockSymbol, currentPrice, paidPrice
//    }
//
//    @Published var stockSymbol = ""
//    @Published var currentPrice = 0.0
//    @Published var paidPrice = 0.0
//    var gainOrLoss: Double {
//        currentPrice - paidPrice
//    }
//    var id =  UUID()
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//
//        try container.encode(stockSymbol, forKey: CodingKeys.stockSymbol)
//        try container.encode(currentPrice, forKey: CodingKeys.currentPrice)
//        try container.encode(paidPrice, forKey: CodingKeys.paidPrice)
//    }
//
////    init(stockSymbol: String, currentPrice: Double, paidPrice: Double, id: UUID) {
////        self.stockSymbol = stockSymbol
////        self.currentPrice = currentPrice
////        self.paidPrice = paidPrice
////        self.id = id
////    }
//
//    init() {}
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        stockSymbol = try container.decode(String.self, forKey: CodingKeys.stockSymbol)
//        currentPrice = try container.decode(Double.self, forKey: CodingKeys.currentPrice)
//        paidPrice = try container.decode(Double.self, forKey: CodingKeys.paidPrice)
//    }
//}


struct Stock: Codable, Identifiable {
    var stockSymbol: String
    var currentPrice: Double
    var paidPrice: Double
    var gainOrLoss: Double {
        currentPrice - paidPrice
    }
    
    var percentageGainOrLoss: String {
        return "\(((currentPrice - paidPrice) / paidPrice) * 100)%"
    }
    
    var id =  UUID()
}

class StocksList: ObservableObject, Codable {
    
    @Published var stocks = [Stock]()
    
    enum CodingKeys: CodingKey {
        case stocks
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(stocks, forKey: CodingKeys.stocks)
    }

    init() {}

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        stocks = try container.decode([Stock].self, forKey: CodingKeys.stocks)
    }
}
