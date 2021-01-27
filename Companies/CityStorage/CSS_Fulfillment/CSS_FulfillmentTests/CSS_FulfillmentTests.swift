//
//  CSS_FulfillmentTests.swift
//  CSS_FulfillmentTests
//
//  Created by Ravi Vooda on 1/25/21.
//  Copyright © 2021 Ravi Vooda. All rights reserved.
//

import XCTest
@testable import CSS_Fulfillment

class DecayManagerDelegateImpl: DecayManagerDelegate {
    var expiredOrder:Order? = nil
    var decayTimeCall: Date? = nil
    
    var expectation = XCTestExpectation(description: "expiration called")
    
    func handleExpiration(order: Order) {
        self.expiredOrder = order
        self.decayTimeCall = Date()
        self.expectation.fulfill()
    }
}

class CSS_FulfillmentTests: XCTestCase {
    
    let decayManager = DecayManager()
    let delegate = DecayManagerDelegateImpl()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        decayManager.delegate = delegate
    }
    
    /*
     * Create an expectation to wait for the expectation to be fulfilled asynchronously
     */
    func testDecayManager_expires() {
        let order = Order(id: UUID(uuidString: "75534993-2b41-4fdc-b3c8-3419ee5eca48")!,
                          name: "test name",
                          temp: .hot,
                          shelfLife: 15,
                          decayRate: 0.5)
        let epochTime = Date().currentTimeMillis()
        let dispatchTime = DispatchTime.now()
        let shelf = Shelf(config: ShelfConfiguration(capacity: 10, decayModifier: 1))
        decayManager.begin(order: order, time: dispatchTime, shelf: shelf)
        
        wait(for: [delegate.expectation], timeout: 15)
        XCTAssertNotNil(delegate.decayTimeCall)
        XCTAssertNotNil(delegate.expiredOrder)
        
        let decayTimeCall = delegate.decayTimeCall!.currentTimeMillis()
        
        XCTAssertEqual(Float(decayTimeCall), Float(epochTime), accuracy: 1000, "delegate should be notified about the expiry")
        
        XCTAssertEqual(delegate.expiredOrder!, order)
    }
}

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
