import Foundation
import SwiftData

enum GoalMetric: String, CaseIterable, Identifiable {
    case earnings = "amount"
    case trips = "trips"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .earnings: "Zarobek"
        case .trips: "Przejazdy"
        }
    }

    var unit: String {
        switch self {
        case .earnings: "zł"
        case .trips: "przejazdów"
        }
    }
}

@Model
final class Goal {
    var name: String
    var metric: String          // GoalMetric rawValue
    var target: Double
    var weekStart: Date         // Monday 00:00 of target week
    var createdAt: Date

    init(name: String, metric: GoalMetric, target: Double, weekStart: Date, createdAt: Date = .now) {
        self.name = name
        self.metric = metric.rawValue
        self.target = target
        self.weekStart = Calendar.current.startOfDay(for: weekStart)
        self.createdAt = createdAt
    }

    var metricValue: GoalMetric {
        GoalMetric(rawValue: metric) ?? .earnings
    }

    var weekEnd: Date {
        Calendar.current.date(byAdding: .day, value: 6, to: weekStart) ?? weekStart
    }

    func isActive(on date: Date = .now) -> Bool {
        let today = Calendar.current.startOfDay(for: date)
        return today >= weekStart && today <= weekEnd
    }

    func isPast(on date: Date = .now) -> Bool {
        Calendar.current.startOfDay(for: date) > weekEnd
    }
}
