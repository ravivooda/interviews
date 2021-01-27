//
//  OrchestratorFactory.swift
//  CSS_Fulfillment
//
//  Created by Ravi Vooda on 1/25/21.
//  Copyright © 2021 Ravi Vooda. All rights reserved.
//

import Foundation

func generate(source:String, shelvesConfiguration: ([Temperature: ShelfConfiguration], ShelfConfiguration)) -> Orchestrator {
    let ingestor = OrderIngestor(source: source)
    
    let kitchen = Kitchen()
    
    let decayManager = DecayManager()
    
    let shelvesOrganizer = ShelvesOrganizer(configurations: shelvesConfiguration.0, overflowConfig: shelvesConfiguration.1, decayManager: decayManager)
    decayManager.delegate = shelvesOrganizer
    
    let pickupService = Pickup(randomGenerator: RandomGeneratorImpl())
    
    let orchestrator = Orchestrator(ingestor: ingestor, kitchen: kitchen, shelvesOrganizer: shelvesOrganizer, pickupService: pickupService)
    ingestor.listener = orchestrator
    kitchen.listener = orchestrator
    pickupService.listener = orchestrator
    
    return orchestrator
}


class RandomGeneratorImpl: RandomGenerator {
    func generateDouble() -> Double {
        return 3.0
    }
}
