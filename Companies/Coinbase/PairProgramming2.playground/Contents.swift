import UIKit

import Network

import CoreData

// Exchange rate calculator

/*
 tickers = {
   "BTC-USD": { "ask": 1000, "bid": 990 },
   "BTC-EUR": { "ask": 1200, "bid": 1150 },
   "ETH-USD": { "ask": 200, "bid": 180 },
   "ETH-EUR": { "ask": 220, "bid": 210 }
 }
 base = 'USD'
 quote = 'EUR'
 */


/*
 
 1 BTC => USD | 990 USD
 1 USD => BTC | 1/1000 BTC
 
 1 BTC = 1150 EURO = 1150/220 ETH = 180 * 1150/220 USD
 
 1 USD => EIURO |
 - BTC: 1/1000 * 1150 = 1.150
 - ETH: 1/200 * 210 = 1.05
 
 Create a marketplace
  - Is this dynamically changing
 
 */

class Exchange {
    
    var adjancecyListMap = [String: [(String, Float)]]()
    
    init(_ data:[String:[String:Float]]) {
        self.adjancecyListMap = parse(data)
    }
    
    private func parse(_ data:[String:[String:Float]]) -> [String: [(String, Float)]] {
        var rets = [String: [(String, Float)]]()
        
        for (currencies, values) in data {
            var askRate = values["ask"]!
            var bidRate = values["bid"]!
            
            let currencySplits = currencies.components(separatedBy: "-")
            let (c1, c2) = (currencySplits[0], currencySplits[1])
            
            var (c1Edges, c2Edges) = (rets[c1, default: []], rets[c2, default:[]])
            c1Edges.append((c2, bidRate))
            c2Edges.append((c1, 1/askRate))
            
            rets[c1] = c1Edges
            rets[c2] = c2Edges
        }
        
        return rets
    }
    
    func getBestExchangeRate(_ base:String, _ quote:String) -> (Bool, Float) {
        var currentPathNodes = Set<String>()
        
        func dfs(_ node:String) -> (Bool, Float) {
            if node == quote {
                return (true, 1)
            }
            
            guard let edgesOut = adjancecyListMap[node] else {
                return (false, -1)
            }
            
            currentPathNodes.insert(node)
            
            var maxCost:Float = 0
            for (nextNode, cost) in edgesOut {
                if currentPathNodes.contains(nextNode) {
                    continue
                }
                
                let (isPossible, subsequentCost) = dfs(nextNode)
                if isPossible {
                    maxCost = max(maxCost, cost * subsequentCost)
                }
            }
            
            currentPathNodes.remove(node)
            
            return (maxCost != 0, maxCost)
        }
        
        return dfs(base)
    }
}

var tickerData = [String:[String:Float]]()
let task = URLSession.shared.dataTask(with: URL(string: "https://api.pro.coinbase.com/products")!) { (data, response, error) in
    guard let data = data, error == nil else {
        print("Error: \(error)")
        return
    }
    
    do {
        let arrayOfDictionaries = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String: Any]]
        for d in arrayOfDictionaries {
            let id = d["id"] as! String
            let ntask = URLSession.shared.dataTask(with: URL(string: "https://api.pro.coinbase.com/products/\(id)/ticker")!) { (ndata, nresponse, nerror) in
                guard let ndata = ndata, nerror == nil else {
                    print("Nerror: \(nerror)")
                    return
                }
                
                do {
                let ticker = try JSONSerialization.jsonObject(with: ndata, options: .allowFragments) as! [String: Any]
                    
                    print(ticker)
                
                tickerData[id] = [
                    "ask" : Float(ticker["ask"] as! String)!,
                    "bid" : Float(ticker["bid"] as! String)!,
                ]
                } catch let error as NSError {
                    print(error)
                }
            }
            
            ntask.resume()
        }
    } catch let error as NSError {
        print(error)
    }
}

task.resume()
    
    /*= [
    "BTC-USD": [ "ask": 1000, "bid": 990 ],
    "BTC-EUR": [ "ask": 1200, "bid": 100 ],
    "ETH-USD": [ "ask": 200, "bid": 180 ],
    "ETH-EUR": [ "ask": 220, "bid": 210 ],
]*/

let e = Exchange(tickerData)


print(e.getBestExchangeRate("USD", "EUR"))

print(e.adjancecyListMap)
