import SwiftData
import Foundation

@Model
class Expense {
    var date: Date
    var category: String  // "Paliwo" | "Myjnia" | "Serwis" | "Inne"
    var amount: Double
    var note: String

    init(date: Date, category: String, amount: Double, note: String = "") {
        self.date = date
        self.category = category
        self.amount = amount
        self.note = note
    }
}
