//
//  Kitchen.swift
//  CSS_Fulfillment
//
//  Created by Ravi Vooda on 1/25/21.
//  Copyright © 2021 Ravi Vooda. All rights reserved.
//

import Foundation

protocol KitchenOrderUpdateListener : class {
    func hasProcessed(order: Order)
}

class Kitchen {
    
    weak var listener:KitchenOrderUpdateListener? = nil
    
    func processOrder(order: Order) {
        self.listener?.hasProcessed(order: order)
    }
}
