import SwiftData
import Foundation

@Model
class DayEntry {
    var date: Date
    var startTime: Date
    var endTime: Date
    var earnings: Double
    var trips: Int
    var note: String

    var hoursWorked: Double { endTime.timeIntervalSince(startTime) / 3600 }
    var hourlyRate: Double { hoursWorked > 0 ? earnings / hoursWorked : 0 }

    init(date: Date, startTime: Date, endTime: Date, earnings: Double, trips: Int, note: String = "") {
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.earnings = earnings
        self.trips = trips
        self.note = note
    }
}
