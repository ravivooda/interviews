//
//  Pickup.swift
//  CSS_Fulfillment
//
//  Created by Ravi Vooda on 1/25/21.
//  Copyright © 2021 Ravi Vooda. All rights reserved.
//

import Foundation

protocol RandomGenerator {
    func generateDouble() -> Double
}

protocol DeliveryPickupListener : class {
    func canPickupOrder(order: Order) -> Bool
}

class Pickup {
    var generator:RandomGenerator
    var orders = [Order: DispatchWorkItem]()
    
    weak var listener: DeliveryPickupListener?
    
    init(randomGenerator: RandomGenerator) {
        self.generator = randomGenerator
    }
    
    func dispatchPickUp(for order:Order) {
        guard self.orders[order] == nil else {
            // Already scheduled
            // Maybe panic
            return
        }
        
        let delta = self.generator.generateDouble()
        let workItem = DispatchWorkItem { [weak self] in
            guard let listener = self?.listener else {
                return
            }
            
            if listener.canPickupOrder(order: order) {
                print("successfully picked up order \(order)")
            } else {
                print("failed to pick up order \(order)")
            }
            self?.orders[order] = nil
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delta, execute: workItem)
        self.orders[order] = workItem
    }
    
    func cancelDispatch(for order:Order) {
        if let d = self.orders[order] {
            d.cancel()
        }
        self.orders[order] = nil
    }
}
