import UIKit

// To make a class usable as a key in sets or dictionary, it needs to implement Hashable protocol
// For example, take class TreeNode

class TreeNode {
    let value = 0
    let left:TreeNode? = nil
    let right:TreeNode? = nil
}

// extension to implement Hashable

extension TreeNode: Hashable {
    var hashValue:Int {
        return ObjectIdentifier(self).hashValue
    }
}

// In addition, Hashable needs to implement Equatable. This can be done as following
extension TreeNode {
    static func ==(lhs:TreeNode, rhs:TreeNode) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}
