import SwiftUI
import SwiftData

struct GoalsChildView: View {
    @Query(filter: #Predicate<Goal> { !$0.isArchived }, sort: \Goal.createdAt, order: .reverse)
    private var activeGoals: [Goal]

    @Query(filter: #Predicate<Goal> { $0.isArchived }, sort: \Goal.createdAt, order: .reverse)
    private var archivedGoals: [Goal]

    @Query private var allEntries: [DayEntry]

    @State private var showArchive = false

    private var weekEarnings: Double {
        let weekStart = iso8601Calendar.dateInterval(of: .weekOfYear, for: .now)!.start
        let weekEnd = iso8601Calendar.date(byAdding: .day, value: 7, to: weekStart)!
        return allEntries.filter { $0.date >= weekStart && $0.date < weekEnd }.reduce(0) { $0 + $1.earnings }
    }

    private var monthEarnings: Double {
        let monthStart = iso8601Calendar.dateInterval(of: .month, for: .now)!.start
        let monthEnd = iso8601Calendar.date(byAdding: .month, value: 1, to: monthStart)!
        return allEntries.filter { $0.date >= monthStart && $0.date < monthEnd }.reduce(0) { $0 + $1.earnings }
    }

    private var allTimeEarnings: Double {
        allEntries.reduce(0) { $0 + $1.earnings }
    }

    private func currentAmount(for goal: Goal) -> Double {
        switch goal.type {
        case "weekly": return weekEarnings
        case "monthly": return monthEarnings
        default: return allTimeEarnings
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if activeGoals.isEmpty {
                Text("Brak aktywnych celów")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 24)
                    .background(Color.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                ForEach(activeGoals) { goal in
                    GoalCardView(goal: goal, currentAmount: currentAmount(for: goal))
                }
            }

            if !archivedGoals.isEmpty {
                Button {
                    withAnimation { showArchive.toggle() }
                } label: {
                    HStack {
                        Image(systemName: showArchive ? "chevron.down" : "chevron.right")
                            .font(.caption)
                        Text("Archiwum (\(archivedGoals.count))")
                            .font(.subheadline)
                    }
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                if showArchive {
                    ForEach(archivedGoals) { goal in
                        GoalCardView(goal: goal, currentAmount: currentAmount(for: goal))
                            .opacity(0.5)
                    }
                }
            }
        }
    }
}
