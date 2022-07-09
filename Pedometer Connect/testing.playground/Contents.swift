import UIKit
import Foundation

let date = Date().timeIntervalSinceReferenceDate
let millisPerHour:Int64 = 3600 * 1000
let millis = Int64(date * 1000)
let seconds = Int64(date)
let hours = seconds / 3600
let hourNow = hours % 24
let hourNowNZT = hourNow + 12
let secondsSinceLastHour = seconds - hours * 3600
let minutesSinceLastHour = secondsSinceLastHour / 60
let millisSinceLastHour = millis - hours * millisPerHour
let millisToNextHour = millisPerHour - millisSinceLastHour
let minutesSinceLastHourFromMillis = millisSinceLastHour / 60 / 1000


var testingArray = [1,2,3,4,5,6,7]

let total = testingArray.reduce(0, {x,y in
    x + y
})
