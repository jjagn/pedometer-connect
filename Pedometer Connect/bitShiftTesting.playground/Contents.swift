import Foundation
import CoreFoundation

let bytes:[UInt8] = [0xFF, 0xFF]

var total:UInt32 = 0
for (index, element) in bytes.reversed().enumerated() {
    let temp:UInt32 = (UInt32(element) << (8*index))
    total += temp
    print("temp: \(temp)")
    print("total: \(total)")
}

