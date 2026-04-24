import SwiftUI
import SwiftData

@main
struct Uber_EarnApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [DayEntry.self, Expense.self, Goal.self, WeekPlan.self])
    }
}
