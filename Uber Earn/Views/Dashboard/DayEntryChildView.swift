import SwiftUI
import SwiftData

struct DayEntryChildView: View {
    @Query private var entries: [DayEntry]
    @Query private var activeGoals: [Goal]

    @State private var selectedEntry: DayEntry? = nil

    init(start: Date, end: Date) {
        _entries = Query(
            filter: #Predicate<DayEntry> { $0.date >= start && $0.date < end },
            sort: \DayEntry.date
        )
        _activeGoals = Query(
            filter: #Predicate<Goal> { !$0.isArchived && $0.type == "weekly" }
        )
    }

    private struct Totals {
        var earnings: Double = 0
        var hours: Double = 0
        var trips: Int = 0
        var hourlyRate: Double { hours > 0 ? earnings / hours : 0 }
    }

    private var totals: Totals {
        entries.reduce(into: Totals()) { acc, e in
            acc.earnings += e.earnings
            acc.hours += e.hoursWorked
            acc.trips += e.trips
        }
    }

    private var weeklyGoal: Goal? { activeGoals.first }
    private var goalProgress: Double {
        guard let goal = weeklyGoal, goal.targetAmount > 0 else { return 0 }
        return min(totals.earnings / goal.targetAmount, 1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                MetricCardView(title: "Przychód", value: totals.earnings.formattedPLN, valueColor: .accent)
                MetricCardView(title: "Wydatki", value: "–", valueColor: .expenseRed)
                MetricCardView(title: "Zysk netto", value: totals.earnings.formattedPLN, valueColor: .white)
                MetricCardView(
                    title: "Stawka godz.",
                    value: totals.hourlyRate > 0 ? "\(Int(totals.hourlyRate)) zł/h" : "–",
                    valueColor: .white
                )
            }

            if let goal = weeklyGoal {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Cel tygodniowy")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.white)
                        Spacer()
                        PercentBadgeView(percent: Int(goalProgress * 100))
                    }
                    ProgressBarView(progress: goalProgress, tint: .accent)
                    Text("\(totals.earnings.formattedPLN) / \(goal.targetAmount.formattedPLN)")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                .padding()
                .background(Color.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            VStack(alignment: .leading, spacing: 0) {
                SectionHeaderView(title: "Dni tygodnia")
                    .padding(.bottom, 8)

                if entries.isEmpty {
                    Text("Brak wpisów w tym tygodniu")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 24)
                } else {
                    ForEach(entries) { entry in
                        DayRowView(entry: entry)
                            .onTapGesture { selectedEntry = entry }
                        if entry != entries.last {
                            Divider().background(Color.white.opacity(0.08))
                        }
                    }
                }
            }
            .padding()
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .sheet(item: $selectedEntry) { entry in
            DayEntryFormView(entry: entry)
        }
    }
}

private struct DayRowView: View {
    let entry: DayEntry

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.accent)
                .frame(width: 8, height: 8)

            Text(dayAbbrevFormatter.string(from: entry.date).capitalized)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.white)
                .frame(width: 44, alignment: .leading)

            Text(String(format: "%.1fh · %d kursów", entry.hoursWorked, entry.trips))
                .font(.caption)
                .foregroundStyle(.gray)

            Spacer()

            Text(entry.earnings.formattedPLN)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.accent)
        }
        .padding(.vertical, 10)
    }
}
