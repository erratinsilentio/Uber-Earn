import SwiftData
import Foundation

@Model
class Goal {
    var name: String
    var type: String           // "weekly" | "monthly" | "oneTime"
    var targetAmount: Double
    var isArchived: Bool
    var createdAt: Date

    init(name: String, type: String, targetAmount: Double, isArchived: Bool = false, createdAt: Date = .now) {
        self.name = name
        self.type = type
        self.targetAmount = targetAmount
        self.isArchived = isArchived
        self.createdAt = createdAt
    }
}
