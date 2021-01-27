//
//  Ingestion.swift
//  CSS_Fulfillment
//
//  Created by Ravi Vooda on 1/25/21.
//  Copyright © 2021 Ravi Vooda. All rights reserved.
//

import Foundation

protocol NewOrderListener :class {
    func receivedOrder(order: Order)
}

// Could use protocol to decouple
class OrderIngestor {
    
    var timeDelta = 0.1 // In seconds
    
    // mocked orders
    let orders: [Order]
    
    weak var listener: NewOrderListener?
    
    // Need to support configuring the timer
    init(source: String) {
        self.orders = OrderIngestor.readFromFile(fileName: source)
    }
    
    func start() {
        var t = 0.0
        for o in orders {
            let nowTime = DispatchTime.now()
            DispatchQueue.main.asyncAfter(deadline: nowTime + t) {
                self.listener?.receivedOrder(order: o)
            }
            t += timeDelta
        }
    }
    
    static private func readFromFile(fileName: String) -> [Order] {
        let splits = fileName.components(separatedBy: ".")
        guard splits.count == 2 else {
            return []
        }
        var rets = [Order]()
        if let path = Bundle.main.path(forResource: splits[0], ofType: splits[1]) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Array<Dictionary<String, AnyObject>> {
                    for result in jsonResult {
                        guard let order = Order.from(dict: result) else {
                            print("failed to create order from \(result)")
                            continue
                        }
                        rets.append(order)
                    }
                }
            } catch {
                print("ran into \(error) when parsing orders from json")
            }
        }
        
        return rets
    }
}
