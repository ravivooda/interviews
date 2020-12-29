import UIKit

func graph(_ n: Int, _ edges: [[Int]]) -> [Int: [Int]] {
    var edgeMaps = [Int: [Int]]()
    
    for e in edges {
        let (e1, e2) = (e[0], e[1])
        var e1Array = edgeMaps[e1, default:[]]
        e1Array.append(e2)
        edgeMaps[e1] = e1Array
        
        var e2Array = edgeMaps[e2, default:[]]
        e2Array.append(e1)
        edgeMaps[e2] = e2Array
    }
    return edgeMaps
}
