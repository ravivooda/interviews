//
//  Shelf.swift
//  CSS_Fulfillment
//
//  Created by Ravi Vooda on 1/25/21.
//  Copyright © 2021 Ravi Vooda. All rights reserved.
//

import Foundation

struct ShelfConfiguration {
    let capacity:Int
    let decayModifier:Int
}

class Shelf {
    var orders : [Order?]
    var config: ShelfConfiguration
    
    init(config: ShelfConfiguration) {
        self.orders = [Order?](repeating: nil, count: config.capacity)
        self.config = config
    }
    
    func insert(order:Order) -> Bool {
        for i in 0..<orders.count {
            if orders[i] == nil {
                orders[i] = order
                return true
            }
        }
        return false
    }
    
    // Currently removes the first
    func removeRandom() -> Order? {
        for i in 0..<orders.count {
            if let order = orders[i] {
                orders[i] = nil
                return order
            }
        }
        return nil
    }
    
    func pickup(for pickupOrder: Order) -> Bool {
        for i in 0..<orders.count {
            if let order = orders[i], order == pickupOrder {
                orders[i] = nil
                return true
            }
        }
        return false
    }
    
    func remove(order removeOrder: Order) -> Bool {
        for i in 0..<orders.count {
            if let order = orders[i], order == removeOrder {
                orders[i] = nil
                return true
            }
        }
        return false
    }
}

extension Shelf : CustomStringConvertible {
    var description: String {
        return "\(orders)"
    }
}
