import UIKit

var str = "Hello, playground"

class Solution {
    func assignBikes(_ workers: [[Int]], _ bikes: [[Int]]) -> Int {
        let endMask = (1<<workers.count)-1
        var cache = [[Int]: (Bool, Int)]()
        func dp(_ bi:Int, _ mask:Int) -> (Bool, Int) {
            if mask == endMask {
                // All bikes are assigned
                return (true, 0)
            }
            
            if bi >= bikes.count {
                return (false, 0)
            }
            
            let index = [bi, mask]
            if let ret = cache[index] {
                return ret
            }
            
            var possibilities = [Int]()
            
            let (notIncludedPossibility, notIncludedMinManhattan) = dp(bi+1, mask)
            if notIncludedPossibility {
                possibilities.append(notIncludedMinManhattan)
            }
            
            // Assign bi to possible workers
            let (bx, by) = (bikes[bi][0], bikes[bi][1])
            for w in 0..<workers.count {
                let nmask = mask & (1 << w)
                if nmask != 0 { continue }
                
                let (isPossible, nextMinManhattan) = dp(bi+1, mask | (1 << w))
                if isPossible {
                    let (wx, wy) = (workers[w][0], workers[w][1])
                    let wnmanhattan = abs(wx-bx) + abs(wy-by)
                    possibilities.append(wnmanhattan + nextMinManhattan)
                }
            }
            
            let p = (possibilities.count > 0, possibilities.min() ?? 0)
            cache[index] = p
            return p
        }
        
        let (_, result) = dp(0,0)
        return result
    }
}

let solution = Solution()
print("Answer is \(solution.assignBikes([[0,0],[1,0],[2,0],[3,0],[4,0]], [[0,999],[1,999],[2,999],[3,999],[4,999]]))")
