import Foundation
import SwiftData

@Model
final class DayEntry {
    // Normalised to start-of-day so one entry maps 1:1 to a calendar day.
    var date: Date
    var trips: Int
    var hoursWorked: Double
    var earnings: Double
    var note: String

    init(date: Date, trips: Int = 0, hoursWorked: Double = 0, earnings: Double = 0, note: String = "") {
        self.date = Calendar.current.startOfDay(for: date)
        self.trips = trips
        self.hoursWorked = hoursWorked
        self.earnings = earnings
        self.note = note
    }

    var hourlyRate: Double {
        hoursWorked > 0 ? earnings / hoursWorked : 0
    }

    var perTrip: Double {
        trips > 0 ? earnings / Double(trips) : 0
    }
}
