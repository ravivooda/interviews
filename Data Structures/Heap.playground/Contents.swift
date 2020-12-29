import UIKit

class Heap<T:Comparable> {
    var sticks:[T] = []
    init(_ sticks: [T]) {
        for e in sticks {
            self.insert(e)
        }
    }
    
    func insert(_ x: T) {
        sticks.append(x)
        
        var curr = sticks.count - 1
        while curr > 0 {
            let parent:Int = (curr-1)/2
            if sticks[parent] <= sticks[curr] {
                break
            }
            
            (sticks[parent], sticks[curr]) = (sticks[curr], sticks[parent])
            curr = parent
        }
    }
    
    func pop() -> T {
        if sticks.count == 1 {
            return sticks.removeLast()
        }
        let retValue = sticks[0]
        sticks[0] = sticks.removeLast()
        var curr = 0
        while true {
            let left = curr * 2 + 1
            if left >= sticks.count {
                break
            }
            
            let right = left + 1
            var swap = left
            if right < sticks.count {
                if sticks[right] < sticks[left] {
                    swap = right
                }
            }
            
            if sticks[curr] < sticks[swap] {
                break
            }
            
            (sticks[swap], sticks[curr]) = (sticks[curr], sticks[swap])
            curr = swap
        }
        return retValue
    }
    
    func count() -> Int {
        return sticks.count
    }
}


let heap = Heap(["1","3","4","5","6","2","20"])
print(heap.sticks)

for i in 0...120 {
    heap.insert("\(i)")
    print("Inserted: \(i), sticks: \(heap.sticks)")
    print("Popped: \(heap.pop()), sticks: \(heap.sticks)\n")
}

for _ in heap.sticks {
    let p = heap.pop()
    print("Popped: \(p), sticks: \(heap.sticks)")
    
    heap.insert("\(Int(p)! * 3)")
}
