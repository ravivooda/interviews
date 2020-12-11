import UIKit
import Foundation

class Solution {
    func generateParenthesis(_ n: Int) -> [String]{
        return Array(generateParenthesis_h(n))
    }
    func generateParenthesis_h(_ n: Int) -> Set<String> {
        if n == 1 {
            return ["()"]
        }
        
        var retArray = Set<String>()
        let subResult = generateParenthesis(n-1)
        print("subResult: \(subResult)")
        for r in subResult {
            retArray = retArray.union(insert(r))
        }
        return retArray
    }
    
    let open:Character = "("
    let close:Character = ")"
    func insert(_ s:String) -> Set<String> {
        var retSet = Set<String> ()
        var left = 0
        var right = 0
        let chars = Array(s)
        var t = 0
        while left <= chars.count {
            if t == 0 {
                right = left
                while right <= chars.count {
                    if t == 0 {
                        let leftOffset = String.Index(encodedOffset: left)
                        let rightOffset = String.Index(encodedOffset: right)
                        print("Left: \(leftOffset) Right: \(right)")
                        print("Left Sub Str: \(s[..<leftOffset])")
                        print("Middle sub str: \(s[leftOffset..<rightOffset])")
                        print("Right sub str: \(s[rightOffset...])")
                        retSet.insert(s[..<leftOffset] + "(" + s[leftOffset..<rightOffset] + ")" + s[rightOffset...])
                    }
                    if right != chars.count {
                        t += (chars[right] == open ? 1 : -1)
                    }
                    right += 1
                }
            }
            if left != chars.count {
                t += (chars[left] == open ? 1 : -1)
            }
            left += 1
        }
        return retSet
    }
}

var s = Solution()
let l = s.generateParenthesis(4)
print(l)
