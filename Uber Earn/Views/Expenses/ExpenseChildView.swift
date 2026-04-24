import SwiftUI
import SwiftData

struct ExpenseChildView: View {
    @Query private var expenses: [Expense]

    init(start: Date, end: Date) {
        _expenses = Query(
            filter: #Predicate<Expense> { $0.date >= start && $0.date < end },
            sort: \Expense.date,
            order: .reverse
        )
    }

    private var total: Double { expenses.reduce(0) { $0 + $1.amount } }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                SectionHeaderView(title: "Suma wydatków")
                Text(total.formattedPLN)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(Color.expenseRed)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            if expenses.isEmpty {
                Text("Brak wydatków w tym tygodniu")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 24)
                    .background(Color.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                VStack(spacing: 0) {
                    ForEach(expenses) { expense in
                        ExpenseRowView(expense: expense)
                        if expense != expenses.last {
                            Divider().background(Color.white.opacity(0.08))
                        }
                    }
                }
                .padding(.horizontal)
                .background(Color.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

private struct ExpenseRowView: View {
    let expense: Expense

    private var emoji: String {
        switch expense.category {
        case "Paliwo": return "⛽"
        case "Myjnia": return "🫧"
        case "Serwis": return "🔧"
        default: return "📦"
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            Text(emoji)
                .font(.title3)
                .frame(width: 36, height: 36)
                .background(Color.white.opacity(0.06))
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text(expense.category)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white)
                Text(shortDateFormatter.string(from: expense.date))
                    .font(.caption)
                    .foregroundStyle(.gray)
            }

            Spacer()

            Text("- \(expense.amount.formattedPLN)")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.expenseRed)
        }
        .padding(.vertical, 12)
    }
}
