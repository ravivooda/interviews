import UIKit

var str = "Hello, playground"

class A {
    var b: B? = nil
}

class B {
    var a: A? = nil
}

var az:A? = A()
var bz:B? = B()

az?.b = bz
bz?.a = az


print(az)

az = nil
