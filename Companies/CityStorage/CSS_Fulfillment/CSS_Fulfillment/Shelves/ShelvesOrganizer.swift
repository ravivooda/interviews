//
//  ShelvesOrganizer.swift
//  CSS_Fulfillment
//
//  Created by Ravi Vooda on 1/25/21.
//  Copyright © 2021 Ravi Vooda. All rights reserved.
//

import Foundation

class ShelvesOrganizer {
    var shelves:[Temperature : Shelf]
    var overflow: Shelf
    
    var decayManager: DecayManager
    
    init(configurations: [Temperature : ShelfConfiguration], overflowConfig: ShelfConfiguration, decayManager: DecayManager) {
        self.shelves = [:]
        for (temp, config) in configurations {
            self.shelves[temp] = Shelf(config: config)
        }
        self.overflow = Shelf(config: overflowConfig)
        self.decayManager = decayManager
    }
    
    func insert(order:Order) -> (Bool, Order?) {
        guard let shelf = self.shelves[order.temp] else {
            // May need to handle in overflow
            return (false, nil)
        }
        
        if shelf.insert(order: order) {
            self.decayManager.begin(order: order, time: .now(), shelf: shelf)
            return (true, nil)
        }
        
        if overflow.insert(order: order) {
            self.decayManager.begin(order: order, time: .now(), shelf: overflow)
            return (true, nil)
        }
        
        for i in 0..<overflow.orders.count {
            if let overflowOrder = overflow.orders[i],
                let shelf = self.shelves[overflowOrder.temp],
                shelf.insert(order: overflowOrder) {
                
                // Update decay manager for moved order
                decayManager.update(order: overflowOrder, shelf: shelf)
                
                // Track for the inserted order
                overflow.orders[i] = nil
                _ = overflow.insert(order: order)
                self.decayManager.begin(order: order, time: .now(), shelf: overflow)
                
                return (true, nil)
            }
        }
        
        if let ro = overflow.removeRandom() {
            decayManager.stop(order: ro)
            let res = overflow.insert(order: order)
            self.decayManager.begin(order: order, time: .now(), shelf: overflow)
            return (res, ro)
        }
        
        return (false, nil)
    }
    
    func pickup(for order:Order) -> Bool {
        for (_, shelf) in shelves {
            if shelf.pickup(for: order) {
                return true
            }
        }
        
        return overflow.pickup(for: order)
    }
}

extension ShelvesOrganizer : CustomStringConvertible {
    var description: String {
        return "Shelves: \(shelves), Overflow: \(overflow)"
    }
}

extension ShelvesOrganizer: DecayManagerDelegate {
    func handleExpiration(order: Order) {
        for (_, shelf) in self.shelves {
            if shelf.remove(order: order) {
                return
            }
        }
        
        if !overflow.remove(order: order) {
            // should panic
        }
    }
}
