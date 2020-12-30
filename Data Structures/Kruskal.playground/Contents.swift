import UIKit

func minimalSpanningTree(_ n:Int, _ nums:[((Int, Int), Int)]) -> [(Int, Int)] {
    var nums = nums
    // This makes it O(E * logE) time complexity
    // But this could be optimized further.
    // We don't need the entire array to be sorted. We only need the top most element
    nums.sort { (a, b) -> Bool in
        return a.1 < b.1
    }
    
    var roots = [Int](repeating: -1, count: n)
    
    func getRoot(_ i: Int) -> Int {
        let p = roots[i]
        if p == -1 {
            return i
        }
        
        let x = getRoot(p)
        roots[i] = x
        return x
    }
    
    var rets = [(Int, Int)]()
    for ((e1, e2), _) in nums {
        let e1Root = getRoot(e1)
        let e2Root = getRoot(e2)
        
        if e1Root != e2Root {
            rets.append((e1, e2))
            roots[e1Root] = e2Root
        }
    }
    
    return rets
}

print(minimalSpanningTree(5, [
    ((0, 1), 1),
    ((0, 3), 7),
    ((1, 3), 5),
    ((1, 2), 4),
    ((2, 4), 2),
    ((1, 4), 3),
    ((3, 4), 1),
    ((0, 4), 1),
]))


