//
//  Orchestrator.swift
//  CSS_Fulfillment
//
//  Created by Ravi Vooda on 1/25/21.
//  Copyright © 2021 Ravi Vooda. All rights reserved.
//

import Foundation

class Orchestrator {
    let ingestor:OrderIngestor
    let kitchen:Kitchen
    let shelvesOrganizer:ShelvesOrganizer
    let pickupService: Pickup
    
    init(ingestor: OrderIngestor, kitchen:Kitchen, shelvesOrganizer:ShelvesOrganizer, pickupService: Pickup) {
        self.ingestor = ingestor
        self.kitchen = kitchen
        self.shelvesOrganizer = shelvesOrganizer
        self.pickupService = pickupService
    }
    
    func start() {
        self.ingestor.start()
    }
}

extension Orchestrator : NewOrderListener {
    func receivedOrder(order: Order) {
        print("Just ingested order \(order)")
        self.kitchen.processOrder(order: order)
    }
}

extension Orchestrator : KitchenOrderUpdateListener {
    func hasProcessed(order: Order) {
        print("Kitchen processed order \(order)")
        let (inserted, droppedOrder) = shelvesOrganizer.insert(order: order)
        if let droppedOrder = droppedOrder {
            pickupService.cancelDispatch(for: droppedOrder)
        }
        if inserted {
            print("successfully organized order \(order)")
            pickupService.dispatchPickUp(for: order)
        } else {
            print("could not organized order \(order)")
        }
        
        print("Shelves: \(shelvesOrganizer)")
    }
}

extension Orchestrator : DeliveryPickupListener {
    func canPickupOrder(order: Order) -> Bool {
        return shelvesOrganizer.pickup(for: order) 
    }
}
