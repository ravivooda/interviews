import UIKit

var cache = [Int:Int]()

func dp(_ i:Int) -> Int {
    // Check if i has crossed a border
    if i >= 100 {
        return 0
    }
    
    if let ret = cache[i] {
        return ret
    }
    
    let p = dp(i-1) + dp(i-2)
    cache[i] = p
    return p
}
