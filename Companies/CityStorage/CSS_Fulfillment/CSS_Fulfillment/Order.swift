//
//  Order.swift
//  CSS_Fulfillment
//
//  Created by Ravi Vooda on 1/25/21.
//  Copyright © 2021 Ravi Vooda. All rights reserved.
//

import Foundation

enum Temperature {
    case hot
    case cold
    case frozen
    
    static func from(input:String) -> Temperature? {
        if input == "hot" {
            return .hot
        }
        
        if input == "cold" {
            return .cold
        }
        
        if input == "frozen" {
            return .frozen
        }
        
        return nil
    }
}

struct Order : Hashable {
    let id:UUID
    let name:String
    let temp:Temperature
    let shelfLife:Int
    let decayRate:Double
}

extension Order {
    static func from(dict:[String: Any]) -> Order? {
        guard let id = UUID(uuidString: dict["id"] as? String ?? ""),
        let name = dict["name"] as? String,
            let temp = Temperature.from(input: dict["temp"] as? String ?? ""),
        let shelfLife = dict["shelfLife"] as? Int,
            let decayRate = dict["decayRate"] as? Double else {
                return nil
        }
        
        return Order(id: id, name: name, temp: temp, shelfLife: shelfLife, decayRate: decayRate)
    }
}

func ==(lhs: Order, rhs: Order) -> Bool {
    return lhs.id == rhs.id
}

extension Order: CustomStringConvertible {
    var description: String {
        return "Order \(id), \(name)"
    }
}

extension Temperature: CustomStringConvertible {
    var description: String {
        switch self {
        case .hot:
            return "hot"
        case .cold:
            return "cold"
        case .frozen:
            return "frozen"
        }
    }
}
