import UIKit

// Tree
// Print out the nodes in zig zag order
//         2
//     3          4
//   1   5      6    7


// [ 2, 4, 3, 1, 5, 6, 7]
// [ 2, 3, 4, 7, 6, 5, 1]


class node {
    let val:Int = 0
    var left:node? = nil
    var right: node? = nil
}

//class queue {
//    func enqueue(_ root:node) {
//
//    }
//
//    func dequeue() -> node? {
//
//    }
//}

// true -> forward
// false -> backward
func printZigZag(_ root:node, _ startingDirection: Bool) {
    var stack = [root] // [1, 5, 6, 7]
    var printArray = [Int]() // [2, 4, 3, 1, 5, 6, 7]
    
    if !startingDirection {
        // Parse the root outside
        
        printArray.append(root.val)
        stack = []
        if let l = root.left {
            stack.append(l)
        }
        
        if let r = root.right {
            stack.append(r)
        }
    }
    
    // Continue parsign
    while stack.count > 0 {
        // Forward
        var backwardStack = [node]() // [3, 4]
        for elem in stack {
            printArray.append(elem.val)
            if let l = elem.left {
                backwardStack.append(l)
            }
            
            if let r = elem.right {
                backwardStack.append(r)
            }
        }
        
        // Backward, for the next level
        stack = []
        for i in (0..<backwardStack.count).reversed() {
            let elem = backwardStack[i] // 3
            printArray.append(elem.val)
            if let r = elem.right {
                stack.append(r)
            }
            if let l = elem.left {
                stack.append(l)
            }
        }
        
        stack.reverse()
    }
    
    print(printArray.map { "\($0)" }.joined(separator: ","))
}
