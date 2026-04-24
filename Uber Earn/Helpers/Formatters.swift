import Foundation

let iso8601Calendar: Calendar = {
    var c = Calendar(identifier: .iso8601)
    c.locale = Locale(identifier: "pl_PL")
    return c
}()

let plnFormatter: NumberFormatter = {
    let f = NumberFormatter()
    f.numberStyle = .decimal
    f.locale = Locale(identifier: "pl_PL")
    f.minimumFractionDigits = 0
    f.maximumFractionDigits = 2
    f.positiveSuffix = " zł"
    return f
}()

let shortDateFormatter: DateFormatter = {
    let f = DateFormatter()
    f.locale = Locale(identifier: "pl_PL")
    f.dateFormat = "d MMM"
    return f
}()

let dayAbbrevFormatter: DateFormatter = {
    let f = DateFormatter()
    f.locale = Locale(identifier: "pl_PL")
    f.dateFormat = "EEE"
    return f
}()

private let weekDayFormatter: DateFormatter = {
    let f = DateFormatter()
    f.locale = Locale(identifier: "pl_PL")
    f.dateFormat = "d"
    return f
}()

private let monthNameFormatter: DateFormatter = {
    let f = DateFormatter()
    f.locale = Locale(identifier: "pl_PL")
    f.dateFormat = "MMMM"
    return f
}()

func weekRangeString(for date: Date) -> String {
    guard
        let monday = iso8601Calendar.dateInterval(of: .weekOfYear, for: date)?.start,
        let sunday = iso8601Calendar.date(byAdding: .day, value: 6, to: monday)
    else { return "" }
    return "\(weekDayFormatter.string(from: monday))–\(weekDayFormatter.string(from: sunday)) \(monthNameFormatter.string(from: sunday))"
}

extension Double {
    var formattedPLN: String {
        plnFormatter.string(from: NSNumber(value: self)) ?? "\(self) zł"
    }
}
