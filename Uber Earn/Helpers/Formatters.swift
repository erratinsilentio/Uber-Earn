import Foundation

let plnFormatter: NumberFormatter = {
    let f = NumberFormatter()
    f.numberStyle = .decimal
    f.locale = Locale(identifier: "pl_PL")
    f.minimumFractionDigits = 0
    f.maximumFractionDigits = 2
    f.positiveSuffix = " zł"
    f.negativeSuffix = " zł"
    return f
}()

let shortDateFormatter: DateFormatter = {
    let f = DateFormatter()
    f.locale = Locale(identifier: "pl_PL")
    f.dateFormat = "d MMM"
    return f
}()

let weekdayFormatter: DateFormatter = {
    let f = DateFormatter()
    f.locale = Locale(identifier: "pl_PL")
    f.dateFormat = "EEEE"
    return f
}()

let weekdayShortFormatter: DateFormatter = {
    let f = DateFormatter()
    f.locale = Locale(identifier: "pl_PL")
    f.dateFormat = "EE"
    return f
}()

extension Double {
    var formattedPLN: String {
        plnFormatter.string(from: NSNumber(value: self)) ?? "\(self) zł"
    }

    var formattedHours: String {
        let rounded = (self * 10).rounded() / 10
        if rounded.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(rounded)) h"
        }
        return String(format: "%.1f h", rounded)
    }
}

extension Int {
    var formattedTrips: String {
        "\(self)"
    }
}
