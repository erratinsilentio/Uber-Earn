import Foundation
import SwiftData

/// Plan tygodnia pracy. `weekdays` używa konwencji Pon=1 … Nd=7
/// (kolejność zgodna z UI), co różni się od `Calendar.weekday`, gdzie
/// Nd=1 … So=7 – mapowanie jest w `Date+Week.swift`.
@Model
final class WeekPlan {
    var weekStart: Date
    var weekdays: [Int]

    init(weekStart: Date, weekdays: [Int] = [1, 2, 3, 4, 5, 6, 7]) {
        self.weekStart = Calendar.current.startOfDay(for: weekStart)
        self.weekdays = weekdays
    }

    static let allDays: [Int] = [1, 2, 3, 4, 5, 6, 7]
    static let labels: [String] = ["Pn", "Wt", "Śr", "Cz", "Pt", "Sb", "Nd"]

    static func label(for weekday: Int) -> String {
        guard (1...7).contains(weekday) else { return "?" }
        return labels[weekday - 1]
    }
}
