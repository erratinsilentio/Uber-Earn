import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allEntries: [DayEntry]
    @Query private var allExpenses: [Expense]
    @Query private var allGoals: [Goal]

    @State private var showEditToday = false
    @State private var showExpenses = false

    private let today = Date()

    private var todayEntry: DayEntry? {
        allEntries.first { $0.date.isSameDay(as: today) }
    }

    private var weekEntries: [DayEntry] {
        allEntries.filter { $0.date.isSameWeek(as: today) }
    }

    private var weekExpenses: [Expense] {
        allExpenses.filter { $0.date.isSameWeek(as: today) }
    }

    private var weekEarnings: Double {
        weekEntries.reduce(0) { $0 + $1.earnings }
    }

    private var weekExpenseTotal: Double {
        weekExpenses.reduce(0) { $0 + $1.amount }
    }

    private var weekTrips: Int {
        weekEntries.reduce(0) { $0 + $1.trips }
    }

    private var weekHours: Double {
        weekEntries.reduce(0) { $0 + $1.hoursWorked }
    }

    private var activeGoal: Goal? {
        allGoals.first { $0.isActive(on: today) }
    }

    var body: some View {
        ZStack {
            AppBackdrop()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    header
                    TodayCard(entry: todayEntry, onEdit: { showEditToday = true })
                    if let goal = activeGoal {
                        GoalProgressCard(
                            goal: goal,
                            weekEarnings: weekEarnings,
                            weekTrips: weekTrips,
                            today: today
                        )
                    } else {
                        emptyGoalCard
                    }
                    WeekSummaryCard(
                        earnings: weekEarnings,
                        expenses: weekExpenseTotal,
                        trips: weekTrips,
                        hours: weekHours,
                        onManageExpenses: { showExpenses = true }
                    )
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 18)
                .padding(.top, 8)
            }
        }
        .sheet(isPresented: $showEditToday) {
            EditDayEntrySheet(
                date: today,
                existing: todayEntry
            )
            .presentationBackground(.ultraThinMaterial)
        }
        .sheet(isPresented: $showExpenses) {
            ExpensesSheet(weekOf: today)
                .presentationBackground(.ultraThinMaterial)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(greeting)
                .font(.appCaption(13, weight: .medium))
                .foregroundStyle(Color.appMuted)
                .textCase(.uppercase)
            Text(dateHeadline)
                .font(.appDisplay(32))
                .foregroundStyle(Color.appWhite)
            Text(weekRangeString(for: today))
                .font(.appBody(14))
                .foregroundStyle(Color.appGold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: today)
        switch hour {
        case 5..<11: return "Dzień dobry"
        case 11..<18: return "Miłego dnia"
        case 18..<23: return "Dobry wieczór"
        default: return "Na nocnej zmianie"
        }
    }

    private var dateHeadline: String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "pl_PL")
        f.dateFormat = "EEEE, d MMMM"
        return f.string(from: today).capitalized
    }

    private var emptyGoalCard: some View {
        GlassCard {
            HStack(alignment: .top, spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color.appGold.opacity(0.15))
                        .frame(width: 44, height: 44)
                    Image(systemName: "target")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.appGold)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Brak aktywnego celu")
                        .font(.appTitle(17))
                        .foregroundStyle(Color.appWhite)
                    Text("Dodaj cel na ten tydzień w zakładce Cele, a pokażę ile musisz pracować, żeby go zrealizować.")
                        .font(.appBody(13))
                        .foregroundStyle(Color.appMuted)
                }
            }
        }
    }
}

#Preview {
    DashboardView()
        .modelContainer(for: [DayEntry.self, Expense.self, Goal.self], inMemory: true)
        .preferredColorScheme(.dark)
}
