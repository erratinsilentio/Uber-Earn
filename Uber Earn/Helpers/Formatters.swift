import Foundation

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
    f.dateFormat = "d MMM"  // e.g. "21 kw."
    return f
}()

func weekRangeString(for date: Date) -> String {
    let calendar = Calendar(identifier: .iso8601)
    guard
        let monday = calendar.dateInterval(of: .weekOfYear, for: date)?.start,
        let sunday = calendar.date(byAdding: .day, value: 6, to: monday)
    else { return "" }

    let dayFormatter = DateFormatter()
    dayFormatter.locale = Locale(identifier: "pl_PL")
    dayFormatter.dateFormat = "d"

    let monthFormatter = DateFormatter()
    monthFormatter.locale = Locale(identifier: "pl_PL")
    monthFormatter.dateFormat = "MMMM"

    let startDay = dayFormatter.string(from: monday)
    let endDay = dayFormatter.string(from: sunday)
    let month = monthFormatter.string(from: sunday)  // use end of week for month name

    return "\(startDay)–\(endDay) \(month)"
}

extension Double {
    var formattedPLN: String {
        plnFormatter.string(from: NSNumber(value: self)) ?? "\(self) zł"
    }
}
