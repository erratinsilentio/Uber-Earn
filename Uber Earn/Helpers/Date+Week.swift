import Foundation

extension Calendar {
    static let iso: Calendar = {
        var c = Calendar(identifier: .iso8601)
        c.firstWeekday = 2 // Monday
        c.minimumDaysInFirstWeek = 4
        c.locale = Locale(identifier: "pl_PL")
        return c
    }()
}

extension Date {
    var startOfDay: Date { Calendar.current.startOfDay(for: self) }

    var weekStart: Date {
        let interval = Calendar.iso.dateInterval(of: .weekOfYear, for: self)
        return interval?.start ?? self.startOfDay
    }

    var weekEnd: Date {
        Calendar.iso.date(byAdding: .day, value: 6, to: weekStart) ?? self
    }

    func addingDays(_ days: Int) -> Date {
        Calendar.iso.date(byAdding: .day, value: days, to: self) ?? self
    }

    func isSameDay(as other: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: other)
    }

    func isSameWeek(as other: Date) -> Bool {
        Calendar.iso.isDate(self, equalTo: other, toGranularity: .weekOfYear)
    }
}

func weekRangeString(for date: Date) -> String {
    let start = date.weekStart
    let end = date.weekEnd

    let dayFmt = DateFormatter()
    dayFmt.locale = Locale(identifier: "pl_PL")
    dayFmt.dateFormat = "d"

    let monthFmt = DateFormatter()
    monthFmt.locale = Locale(identifier: "pl_PL")
    monthFmt.dateFormat = "LLLL"

    let startMonthFmt = DateFormatter()
    startMonthFmt.locale = Locale(identifier: "pl_PL")
    startMonthFmt.dateFormat = "LLL"

    let startMonth = Calendar.iso.component(.month, from: start)
    let endMonth = Calendar.iso.component(.month, from: end)

    if startMonth == endMonth {
        return "\(dayFmt.string(from: start))–\(dayFmt.string(from: end)) \(monthFmt.string(from: end))"
    } else {
        return "\(dayFmt.string(from: start)) \(startMonthFmt.string(from: start)) – \(dayFmt.string(from: end)) \(startMonthFmt.string(from: end))"
    }
}

func daysOfWeek(containing date: Date) -> [Date] {
    let start = date.weekStart
    return (0..<7).compactMap { Calendar.iso.date(byAdding: .day, value: $0, to: start) }
}

/// Remaining days (today + future) inside the week containing `date`.
func remainingDaysInWeek(from date: Date = .now) -> Int {
    let today = date.startOfDay
    let end = date.weekEnd
    let comps = Calendar.iso.dateComponents([.day], from: today, to: end)
    return max(0, (comps.day ?? 0) + 1)
}

/// Konwertuje datę do indeksu "planowego" dnia tygodnia: Pon=1 … Nd=7.
/// `Calendar.weekday` zwraca Nd=1 … So=7 niezależnie od `firstWeekday`.
func planWeekday(of date: Date) -> Int {
    let w = Calendar.iso.component(.weekday, from: date)
    return w == 1 ? 7 : w - 1
}

/// Liczba zaplanowanych dni pracy od dziś do końca tygodnia (wliczając dziś,
/// jeśli jest w planie).
func remainingPlannedDays(from date: Date, plan weekdays: [Int]) -> Int {
    let today = planWeekday(of: date)
    return weekdays.filter { $0 >= today }.count
}
