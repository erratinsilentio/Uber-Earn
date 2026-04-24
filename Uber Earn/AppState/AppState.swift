import Foundation
import Observation

@Observable
class AppState {
    var selectedWeekStart: Date

    init() {
        selectedWeekStart = iso8601Calendar.dateInterval(of: .weekOfYear, for: .now)!.start
    }

    var weekInterval: DateInterval {
        let end = iso8601Calendar.date(byAdding: .day, value: 7, to: selectedWeekStart)!
        return DateInterval(start: selectedWeekStart, end: end)
    }

    var weekLabel: String {
        weekRangeString(for: selectedWeekStart)
    }

    var isCurrentWeek: Bool {
        let thisWeekStart = iso8601Calendar.dateInterval(of: .weekOfYear, for: .now)!.start
        return selectedWeekStart == thisWeekStart
    }

    func goToPreviousWeek() {
        selectedWeekStart = iso8601Calendar.date(byAdding: .day, value: -7, to: selectedWeekStart)!
    }

    func goToNextWeek() {
        selectedWeekStart = iso8601Calendar.date(byAdding: .day, value: 7, to: selectedWeekStart)!
    }
}
