//
//  Order.swift
//  CupcakeCorner
//
//  Created by Anay Sahu on 7/26/23.
//

import SwiftUI

//class Order: ObservableObject, Codable {
//    enum CodingKeys: CodingKey {
//        case type, cakeAmount, extraFrosting, extraSprinkles, name, address, city, zip
//    }
//
//    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
//
//    @Published var type = 0
//    @Published var cakeAmount = 3
//
//    @Published var specialRequest = false {
//        didSet {
//            if specialRequest == false {
//                extraFrosting = false
//                extraSprinkles = false
//            }
//        }
//    }
//    @Published var extraFrosting = false
//    @Published var extraSprinkles = false
//
//    @Published var name = ""
//    @Published var address = ""
//    @Published var city = ""
//    @Published var zip = ""
//
//    var hasValidDetails: Bool {
//        if name.trimmingCharacters(in: .whitespaces).isEmpty || address.trimmingCharacters(in: .whitespaces).isEmpty || city.trimmingCharacters(in: .whitespaces).isEmpty || zip.trimmingCharacters(in: .whitespaces).isEmpty {
//            return false
//        }
//
//        return true
//    }
//
//    var cost: Double {
//        // $2 per cake
//        var cost = Double(cakeAmount) * 2
//
//        // complicated cakes cost more
//        cost += (Double(type) / 2)
//
//        // $1/cake for extra frosting
//        if extraFrosting {
//            cost += Double(cakeAmount)
//        }
//
//        // $0.50/cake for sprinkles
//        if extraSprinkles {
//            cost += Double(cakeAmount) / 2
//        }
//
//        return cost
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//
//        try container.encode(type, forKey: .type)
//        try container.encode(cakeAmount, forKey: .cakeAmount)
//
//        try container.encode(extraFrosting, forKey: .extraFrosting)
//        try container.encode(extraSprinkles, forKey: .extraSprinkles)
//
//        try container.encode(name, forKey: .name)
//        try container.encode(address, forKey: .address)
//        try container.encode(city, forKey: .city)
//        try container.encode(zip, forKey: .zip)
//    }
//
//    init() {}
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        type = try container.decode(Int.self, forKey: .type)
//        cakeAmount = try container.decode(Int.self, forKey: .cakeAmount)
//
//        extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
//        extraSprinkles = try container.decode(Bool.self, forKey: .extraSprinkles)
//
//        name = try container.decode(String.self, forKey: .name)
//        address = try container.decode(String.self, forKey: .address)
//        city = try container.decode(String.self, forKey: .city)
//        zip = try container.decode(String.self, forKey: .zip)
//
//
//    }
//}

struct OrderDetails: Codable {
//    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var cakeAmount = 3
    
    var specialRequest = false {
        didSet {
            if specialRequest == false {
                extraFrosting = false
                extraSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var extraSprinkles = false
    
    var name = ""
    var address = ""
    var city = ""
    var zip = ""
    
    var hasValidDetails: Bool {
        if name.trimmingCharacters(in: .whitespaces).isEmpty || address.trimmingCharacters(in: .whitespaces).isEmpty || city.trimmingCharacters(in:.whitespaces).isEmpty || zip.trimmingCharacters(in: .whitespaces).isEmpty {
                return false
            }
    
            return true
        }
    
        var cost: Double {
            // $2 per cake
            var cost = Double(cakeAmount) * 2
    
            // complicated cakes cost more
            cost += (Double(type) / 2)
    
            // $1/cake for extra frosting
            if extraFrosting {
                cost += Double(cakeAmount)
            }
    
            // $0.50/cake for sprinkles
            if extraSprinkles {
                cost += Double(cakeAmount) / 2
            }
    
            return cost
        }
}

class Order: ObservableObject, Codable {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    enum CodingKeys: CodingKey {
        case orderDetails
    }
    
    @Published var orderDetails = OrderDetails()
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(orderDetails, forKey: .orderDetails)
    }
    
    init() {}
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        orderDetails = try container.decode(OrderDetails.self, forKey: .orderDetails)
    }
}
