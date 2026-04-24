import Foundation
import SwiftData

enum ExpenseCategory: String, CaseIterable, Identifiable {
    case rental = "Wynajem"
    case fuel = "Paliwo"
    case wash = "Myjnia"
    case service = "Serwis"
    case other = "Inne"

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .rental: "key.fill"
        case .fuel: "fuelpump.fill"
        case .wash: "drop.fill"
        case .service: "wrench.and.screwdriver.fill"
        case .other: "ellipsis.circle.fill"
        }
    }
}

@Model
final class Expense {
    var date: Date
    var category: String
    var amount: Double
    var note: String

    init(date: Date, category: ExpenseCategory, amount: Double, note: String = "") {
        self.date = date
        self.category = category.rawValue
        self.amount = amount
        self.note = note
    }

    var categoryValue: ExpenseCategory {
        ExpenseCategory(rawValue: category) ?? .other
    }
}
