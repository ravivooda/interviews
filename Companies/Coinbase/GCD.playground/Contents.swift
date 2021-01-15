import UIKit

var str = "Hello, playground"

let group = DispatchGroup()
let queue = DispatchQueue(label: "com.theswiftdev.queues.serial")
let workItem = DispatchWorkItem {
    print("start")
    sleep(1)
    print("end")
}

queue.async(group: group) {
    print("group start")
    sleep(2)
    print("group end")
}
DispatchQueue.global().async(group: group, execute: workItem)

// you can block your current queue and wait until the group is ready
// a better way is to use a notification block instead of blocking
//group.wait(timeout: .now() + .seconds(3))
//print("done")

group.notify(queue: .main) {
    print("done")
}

////////////////////

enum DispatchError: Error {
    case timeout
}

func asyncMethod(completion: (String) -> Void) {
    sleep(2)
    completion("done")
}

func syncMethod() throws -> String {

    let semaphore = DispatchSemaphore(value: 0)
    let queue = DispatchQueue.global()

    var response: String?
    queue.async {
        asyncMethod { r in
            response = r
            semaphore.signal()
        }
    }
    semaphore.wait(timeout: .now() + 5)
    guard let result = response else {
        throw DispatchError.timeout
    }
    return result
}

let response = try? syncMethod()
print(response)
