import SwiftUI
import SwiftData

struct GoalsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Goal.weekStart, order: .reverse) private var allGoals: [Goal]
    @Query private var allEntries: [DayEntry]

    @State private var showAdd = false
    private let today = Date()

    private var active: [Goal] {
        allGoals.filter { $0.isActive(on: today) }
    }

    private var past: [Goal] {
        allGoals.filter { $0.isPast(on: today) }
    }

    private var upcoming: [Goal] {
        allGoals.filter { $0.weekStart > today.weekEnd }
    }

    var body: some View {
        ZStack {
            AppBackdrop()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    header

                    Button { showAdd = true } label: {
                        Label("Nowy cel", systemImage: "plus")
                    }
                    .buttonStyle(PrimaryButtonStyle())

                    if !active.isEmpty {
                        section(title: "Aktywne") {
                            ForEach(active) { goal in
                                GoalCard(goal: goal, entries: entriesFor(goal), today: today, onDelete: { delete(goal) })
                            }
                        }
                    }

                    if !upcoming.isEmpty {
                        section(title: "Nadchodzące") {
                            ForEach(upcoming) { goal in
                                GoalCard(goal: goal, entries: entriesFor(goal), today: today, onDelete: { delete(goal) })
                            }
                        }
                    }

                    if !past.isEmpty {
                        section(title: "Przeszłe") {
                            ForEach(past) { goal in
                                GoalCard(goal: goal, entries: entriesFor(goal), today: today, onDelete: { delete(goal) })
                            }
                        }
                    }

                    if allGoals.isEmpty {
                        GlassCard {
                            VStack(spacing: 10) {
                                Image(systemName: "target")
                                    .font(.system(size: 32))
                                    .foregroundStyle(Color.appGold)
                                Text("Brak celów")
                                    .font(.appTitle(17))
                                    .foregroundStyle(Color.appWhite)
                                Text("Dodaj cel tygodnia, żeby widzieć postęp i potrzebne tempo pracy.")
                                    .font(.appBody(13))
                                    .foregroundStyle(Color.appMuted)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                        }
                    }

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 18)
                .padding(.top, 8)
            }
        }
        .sheet(isPresented: $showAdd) {
            EditGoalSheet()
                .presentationBackground(.ultraThinMaterial)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Cele")
                .font(.appDisplay(32))
                .foregroundStyle(Color.appWhite)
            Text("Ustaw cel tygodnia i śledź postęp")
                .font(.appBody(14))
                .foregroundStyle(Color.appMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
    }

    private func section<C: View>(title: String, @ViewBuilder content: () -> C) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.appCaption(12, weight: .semibold))
                .foregroundStyle(Color.appMuted)
                .textCase(.uppercase)
                .padding(.horizontal, 4)
            content()
        }
    }

    private func entriesFor(_ goal: Goal) -> [DayEntry] {
        allEntries.filter { $0.date >= goal.weekStart && $0.date <= goal.weekEnd }
    }

    private func delete(_ goal: Goal) {
        modelContext.delete(goal)
        try? modelContext.save()
    }
}

struct GoalCard: View {
    let goal: Goal
    let entries: [DayEntry]
    let today: Date
    var onDelete: () -> Void

    private var currentValue: Double {
        switch goal.metricValue {
        case .earnings: entries.reduce(0) { $0 + $1.earnings }
        case .trips: Double(entries.reduce(0) { $0 + $1.trips })
        }
    }

    private var progress: Double {
        guard goal.target > 0 else { return 0 }
        return min(1, currentValue / goal.target)
    }

    private var statusLabel: String {
        if progress >= 1 { return "Zrealizowany" }
        if goal.isPast(on: today) { return "Niezrealizowany" }
        if goal.isActive(on: today) { return "W toku" }
        return "Nadchodzący"
    }

    private var statusColor: Color {
        if progress >= 1 { return .appGold }
        if goal.isPast(on: today) { return .appDanger }
        if goal.isActive(on: today) { return .appGoldSoft }
        return .appMuted
    }

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(goal.name)
                            .font(.appTitle(17))
                            .foregroundStyle(Color.appWhite)
                        Text(weekRangeString(for: goal.weekStart))
                            .font(.appCaption(12))
                            .foregroundStyle(Color.appMuted)
                    }
                    Spacer()
                    Text(statusLabel)
                        .font(.appCaption(11, weight: .semibold))
                        .foregroundStyle(statusColor)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background {
                            Capsule().fill(statusColor.opacity(0.14))
                        }
                }

                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text(valueLabel(currentValue))
                        .font(.appDisplay(26))
                        .foregroundStyle(LinearGradient.goldSheen)
                    Text("/ \(valueLabel(goal.target))")
                        .font(.appBody(14))
                        .foregroundStyle(Color.appMuted)
                    Spacer()
                    Text("\(Int((progress * 100).rounded()))%")
                        .font(.appNumber(16, weight: .bold))
                        .foregroundStyle(Color.appWhite)
                }

                ProgressBar(progress: progress)

                HStack(spacing: 6) {
                    Image(systemName: goal.metricValue == .earnings ? "banknote.fill" : "car.fill")
                        .font(.system(size: 11))
                        .foregroundStyle(Color.appGold)
                    Text(goal.metricValue.label)
                        .font(.appCaption(12, weight: .medium))
                        .foregroundStyle(Color.appMuted)
                }
            }
        }
        .contextMenu {
            Button(role: .destructive, action: onDelete) {
                Label("Usuń cel", systemImage: "trash")
            }
        }
    }

    private func valueLabel(_ v: Double) -> String {
        switch goal.metricValue {
        case .earnings: v.formattedPLN
        case .trips: "\(Int(v))"
        }
    }
}

struct ProgressBar: View {
    let progress: Double

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(Color.white.opacity(0.08))
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(LinearGradient.goldSheen)
                    .frame(width: max(4, geo.size.width * max(0, min(1, progress))))
            }
        }
        .frame(height: 8)
    }
}

struct EditGoalSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var metric: GoalMetric = .earnings
    @State private var target: String = ""
    @State private var weekAnchor: Date = Date()

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackdrop()
                ScrollView {
                    VStack(spacing: 16) {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 14) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Nazwa")
                                        .font(.appCaption(11, weight: .semibold))
                                        .foregroundStyle(Color.appMuted)
                                        .textCase(.uppercase)
                                    TextField("np. Na czynsz", text: $name)
                                        .font(.appBody(16, weight: .semibold))
                                        .foregroundStyle(Color.appWhite)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 12)
                                        .background {
                                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                .fill(Color.white.opacity(0.04))
                                        }
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                .stroke(Color.white.opacity(0.08), lineWidth: 1)
                                        }
                                }

                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Metryka")
                                        .font(.appCaption(11, weight: .semibold))
                                        .foregroundStyle(Color.appMuted)
                                        .textCase(.uppercase)
                                    HStack(spacing: 8) {
                                        ForEach(GoalMetric.allCases) { m in
                                            MetricChip(metric: m, selected: metric == m) {
                                                metric = m
                                            }
                                        }
                                    }
                                }

                                FieldRow(
                                    label: metric == .earnings ? "Cel (zł)" : "Cel (przejazdy)",
                                    suffix: metric == .earnings ? "zł" : "",
                                    text: $target,
                                    keyboard: metric == .earnings ? .decimalPad : .numberPad,
                                    symbol: metric == .earnings ? "banknote.fill" : "car.fill"
                                )

                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Tydzień")
                                        .font(.appCaption(11, weight: .semibold))
                                        .foregroundStyle(Color.appMuted)
                                        .textCase(.uppercase)
                                    DatePicker(
                                        "Tydzień",
                                        selection: $weekAnchor,
                                        displayedComponents: .date
                                    )
                                    .datePickerStyle(.compact)
                                    .labelsHidden()
                                    .tint(Color.appGold)
                                    .environment(\.locale, Locale(identifier: "pl_PL"))
                                    Text(weekRangeString(for: weekAnchor))
                                        .font(.appCaption(12, weight: .medium))
                                        .foregroundStyle(Color.appGold)
                                }
                            }
                        }

                        Button(action: save) {
                            Text("Zapisz cel")
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .disabled(!canSave)
                        .opacity(canSave ? 1 : 0.5)
                    }
                    .padding(18)
                }
            }
            .navigationTitle("Nowy cel")
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

    private var parsedTarget: Double {
        Double(target.replacingOccurrences(of: ",", with: ".")) ?? 0
    }

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty && parsedTarget > 0
    }

    private func save() {
        guard canSave else { return }
        let goal = Goal(
            name: name.trimmingCharacters(in: .whitespaces),
            metric: metric,
            target: parsedTarget,
            weekStart: weekAnchor.weekStart
        )
        modelContext.insert(goal)
        try? modelContext.save()
        dismiss()
    }
}

struct MetricChip: View {
    let metric: GoalMetric
    let selected: Bool
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                Image(systemName: metric == .earnings ? "banknote.fill" : "car.fill")
                    .font(.system(size: 12, weight: .semibold))
                Text(metric.label)
                    .font(.appCaption(13, weight: .semibold))
            }
            .padding(.horizontal, 14)
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
