//
//  DecayManager.swift
//  CSS_Fulfillment
//
//  Created by Ravi Vooda on 1/25/21.
//  Copyright © 2021 Ravi Vooda. All rights reserved.
//

import Foundation

protocol DecayManagerDelegate : class {
    func handleExpiration(order: Order)
}

class DecayManager {
    var trackedOrders = [Order: DispatchWorkItem]()
    weak var delegate: DecayManagerDelegate?
    
    func begin(order: Order, time: DispatchTime, shelf:Shelf) {
        guard trackedOrders[order] == nil else {
            return
        }
        
        let expiry = time + Double(order.shelfLife) / ( 1.0 + order.decayRate * Double(shelf.config.decayModifier))
        
        let d = DispatchWorkItem { [weak self] in
            self?.delegate?.handleExpiration(order: order)
        }
        trackedOrders[order] = d
        DispatchQueue.main.asyncAfter(deadline: expiry, execute: d)
    }
    
    func update(order: Order, shelf: Shelf) {
        
    }
    
    func stop(order: Order) {
        
    }
}
