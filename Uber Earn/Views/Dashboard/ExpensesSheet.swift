import SwiftUI
import SwiftData

struct ExpensesSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var allExpenses: [Expense]

    let weekOf: Date
    @State private var showAdd = false

    private var weekExpenses: [Expense] {
        allExpenses
            .filter { $0.date.isSameWeek(as: weekOf) }
            .sorted { $0.date > $1.date }
    }

    private var total: Double {
        weekExpenses.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackdrop()
                ScrollView {
                    VStack(spacing: 16) {
                        GlassCard(tint: .appDanger) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Suma tygodnia")
                                    .font(.appCaption(12, weight: .semibold))
                                    .foregroundStyle(Color.appMuted)
                                    .textCase(.uppercase)
                                Text(total.formattedPLN)
                                    .font(.appDisplay(32))
                                    .foregroundStyle(Color.appWhite)
                                Text(weekRangeString(for: weekOf))
                                    .font(.appBody(13))
                                    .foregroundStyle(Color.appGold)
                            }
                        }

                        Button { showAdd = true } label: {
                            Label("Dodaj wydatek", systemImage: "plus")
                        }
                        .buttonStyle(PrimaryButtonStyle())

                        if weekExpenses.isEmpty {
                            GlassCard {
                                VStack(spacing: 6) {
                                    Image(systemName: "tray")
                                        .font(.system(size: 26))
                                        .foregroundStyle(Color.appMuted)
                                    Text("Brak wydatków w tym tygodniu")
                                        .font(.appBody(14))
                                        .foregroundStyle(Color.appMuted)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                            }
                        } else {
                            GlassCard {
                                VStack(spacing: 0) {
                                    ForEach(Array(weekExpenses.enumerated()), id: \.element.persistentModelID) { idx, expense in
                                        ExpenseRow(expense: expense) {
                                            modelContext.delete(expense)
                                            try? modelContext.save()
                                        }
                                        if idx < weekExpenses.count - 1 {
                                            Divider().overlay(Color.white.opacity(0.06))
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(18)
                }
            }
            .navigationTitle("Wydatki")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Zamknij") { dismiss() }
                        .foregroundStyle(Color.appGold)
                }
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
            .sheet(isPresented: $showAdd) {
                AddExpenseSheet(weekOf: weekOf)
                    .presentationDetents([.medium, .large])
                    .presentationBackground(.ultraThinMaterial)
            }
        }
    }
}

struct ExpenseRow: View {
    let expense: Expense
    var onDelete: () -> Void

    private static let dateFmt: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "pl_PL")
        f.dateFormat = "EEE, d MMM"
        return f
    }()

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(Color.appDanger.opacity(0.14)).frame(width: 36, height: 36)
                Image(systemName: expense.categoryValue.symbol)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.appDanger)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(expense.categoryValue.rawValue)
                    .font(.appBody(14, weight: .semibold))
                    .foregroundStyle(Color.appWhite)
                Text(Self.dateFmt.string(from: expense.date))
                    .font(.appCaption(11))
                    .foregroundStyle(Color.appMuted)
                if !expense.note.isEmpty {
                    Text(expense.note)
                        .font(.appCaption(12))
                        .foregroundStyle(Color.appMuted)
                        .lineLimit(1)
                }
            }
            Spacer()
            Text(expense.amount.formattedPLN)
                .font(.appNumber(15, weight: .semibold))
                .foregroundStyle(Color.appWhite)
        }
        .padding(.vertical, 10)
        .swipeActions(edge: .trailing) {
            Button(role: .destructive, action: onDelete) {
                Label("Usuń", systemImage: "trash")
            }
        }
        .contextMenu {
            Button(role: .destructive, action: onDelete) {
                Label("Usuń", systemImage: "trash")
            }
        }
    }
}

struct AddExpenseSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let weekOf: Date
    @State private var category: ExpenseCategory = .fuel
    @State private var amount: String = ""
    @State private var note: String = ""
    @State private var date: Date

    init(weekOf: Date) {
        self.weekOf = weekOf
        let isCurrent = weekOf.isSameWeek(as: Date())
        _date = State(initialValue: isCurrent ? Date() : weekOf.weekStart)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackdrop()
                ScrollView {
                    VStack(spacing: 16) {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 14) {
                                Text("Kategoria")
                                    .font(.appCaption(11, weight: .semibold))
                                    .foregroundStyle(Color.appMuted)
                                    .textCase(.uppercase)
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 8)], spacing: 8) {
                                    ForEach(ExpenseCategory.allCases) { c in
                                        CategoryChip(category: c, selected: category == c) {
                                            category = c
                                        }
                                    }
                                }
                            }
                        }

                        GlassCard {
                            VStack(alignment: .leading, spacing: 14) {
                                FieldRow(
                                    label: "Kwota",
                                    suffix: "zł",
                                    text: $amount,
                                    keyboard: .decimalPad,
                                    symbol: "banknote.fill"
                                )
                                DatePicker(
                                    "Data",
                                    selection: $date,
                                    in: weekOf.weekStart...weekOf.weekEnd,
                                    displayedComponents: .date
                                )
                                .datePickerStyle(.compact)
                                .tint(Color.appGold)
                                .foregroundStyle(Color.appText)
                                .environment(\.locale, Locale(identifier: "pl_PL"))

                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Notatka")
                                        .font(.appCaption(11, weight: .semibold))
                                        .foregroundStyle(Color.appMuted)
                                        .textCase(.uppercase)
                                    TextField("Opcjonalnie", text: $note, axis: .vertical)
                                        .font(.appBody(15))
                                        .foregroundStyle(Color.appWhite)
                                        .lineLimit(1...3)
                                }
                            }
                        }

                        Button(action: save) {
                            Text("Zapisz wydatek")
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .disabled(parsedAmount <= 0)
                        .opacity(parsedAmount <= 0 ? 0.5 : 1)
                    }
                    .padding(18)
                }
            }
            .navigationTitle("Nowy wydatek")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Anuluj") { dismiss() }
                        .foregroundStyle(Color.appGold)
                }
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    private var parsedAmount: Double {
        Double(amount.replacingOccurrences(of: ",", with: ".")) ?? 0
    }

    private func save() {
        guard parsedAmount > 0 else { return }
        let expense = Expense(date: date, category: category, amount: parsedAmount, note: note)
        modelContext.insert(expense)
        try? modelContext.save()
        dismiss()
    }
}

struct CategoryChip: View {
    let category: ExpenseCategory
    let selected: Bool
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                Image(systemName: category.symbol)
                    .font(.system(size: 12, weight: .semibold))
                Text(category.rawValue)
                    .font(.appCaption(13, weight: .semibold))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .foregroundStyle(selected ? Color.black : Color.appWhite)
            .background {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(selected ? AnyShapeStyle(LinearGradient.goldSheen) : AnyShapeStyle(Color.white.opacity(0.05)))
            }
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(selected ? Color.clear : Color.white.opacity(0.08), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }
}
