import SwiftUI
import SwiftData
import Charts

struct StatsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allEntries: [DayEntry]
    @Query private var allExpenses: [Expense]

    @State private var anchor: Date = Date()
    @State private var showExpenses = false
    @State private var editingDate: Date?

    private var entries: [DayEntry] {
        allEntries
            .filter { $0.date.isSameWeek(as: anchor) }
            .sorted { $0.date < $1.date }
    }

    private var expenses: [Expense] {
        allExpenses.filter { $0.date.isSameWeek(as: anchor) }
    }

    private var totalEarnings: Double { entries.reduce(0) { $0 + $1.earnings } }
    private var totalExpenses: Double { expenses.reduce(0) { $0 + $1.amount } }
    private var totalTrips: Int { entries.reduce(0) { $0 + $1.trips } }
    private var totalHours: Double { entries.reduce(0) { $0 + $1.hoursWorked } }
    private var balance: Double { totalEarnings - totalExpenses }
    private var avgPerHour: Double { totalHours > 0 ? totalEarnings / totalHours : 0 }
    private var avgPerTrip: Double { totalTrips > 0 ? totalEarnings / Double(totalTrips) : 0 }

    var body: some View {
        ZStack {
            AppBackdrop()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 18) {
                    header
                    weekPicker
                    totalsCard
                    chartCard
                    daysCard
                    Button { showExpenses = true } label: {
                        Label("Wydatki (\(expenses.count))", systemImage: "creditcard.fill")
                    }
                    .buttonStyle(GhostButtonStyle())
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 18)
                .padding(.top, 8)
            }
        }
        .sheet(isPresented: $showExpenses) {
            ExpensesSheet(weekOf: anchor)
                .presentationBackground(.ultraThinMaterial)
        }
        .sheet(item: Binding(
            get: { editingDate.map(DateWrapper.init) },
            set: { editingDate = $0?.date }
        )) { wrapper in
            EditDayEntrySheet(
                date: wrapper.date,
                existing: allEntries.first { $0.date.isSameDay(as: wrapper.date) }
            )
            .presentationBackground(.ultraThinMaterial)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Statystyki")
                .font(.appDisplay(32))
                .foregroundStyle(Color.appWhite)
            Text(weekRangeString(for: anchor))
                .font(.appBody(14))
                .foregroundStyle(Color.appGold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
    }

    private var weekPicker: some View {
        GlassCard(padding: 14) {
            HStack(spacing: 10) {
                Button { shiftWeek(-1) } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.appGold)
                        .frame(width: 36, height: 36)
                        .background {
                            Circle().fill(Color.white.opacity(0.05))
                        }
                }
                .buttonStyle(.plain)

                Spacer()

                VStack(spacing: 2) {
                    Text(anchor.isSameWeek(as: Date()) ? "Bieżący tydzień" : "Tydzień")
                        .font(.appCaption(11, weight: .semibold))
                        .foregroundStyle(Color.appMuted)
                        .textCase(.uppercase)
                    Text(weekRangeString(for: anchor))
                        .font(.appBody(15, weight: .semibold))
                        .foregroundStyle(Color.appWhite)
                }

                Spacer()

                Button { shiftWeek(1) } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.appGold)
                        .frame(width: 36, height: 36)
                        .background {
                            Circle().fill(Color.white.opacity(0.05))
                        }
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var totalsCard: some View {
        GlassCard(tint: .appGold) {
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Saldo tygodnia")
                            .font(.appCaption(12, weight: .semibold))
                            .foregroundStyle(Color.appMuted)
                            .textCase(.uppercase)
                        Text(balance.formattedPLN)
                            .font(.appDisplay(34))
                            .foregroundStyle(balance >= 0 ? AnyShapeStyle(LinearGradient.goldSheen) : AnyShapeStyle(Color.appDanger))
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                    }
                    Spacer()
                }

                Divider().overlay(Color.white.opacity(0.08))

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    MiniStat(label: "Zarobki", value: totalEarnings.formattedPLN, accent: .appGold)
                    MiniStat(label: "Wydatki", value: totalExpenses.formattedPLN, accent: .appDanger)
                    MiniStat(label: "Przejazdy", value: "\(totalTrips)", accent: .appWhite)
                    MiniStat(label: "Godziny", value: totalHours.formattedHours, accent: .appWhite)
                    MiniStat(label: "Średnio / h", value: avgPerHour.formattedPLN, accent: .appGoldSoft)
                    MiniStat(label: "Średnio / przejazd", value: avgPerTrip.formattedPLN, accent: .appGoldSoft)
                }
            }
        }
    }

    private var chartCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Zarobki dzienne")
                        .font(.appTitle(16))
                        .foregroundStyle(Color.appWhite)
                    Spacer()
                    Text("zł")
                        .font(.appCaption(11))
                        .foregroundStyle(Color.appMuted)
                }
                Chart {
                    ForEach(daysOfWeek(containing: anchor), id: \.self) { day in
                        let value = entries.first { $0.date.isSameDay(as: day) }?.earnings ?? 0
                        BarMark(
                            x: .value("Dzień", day, unit: .day),
                            y: .value("Zarobek", value)
                        )
                        .foregroundStyle(LinearGradient.goldSheen)
                        .cornerRadius(6)
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { value in
                        AxisValueLabel(format: .dateTime.weekday(.narrow).locale(Locale(identifier: "pl_PL")))
                            .foregroundStyle(Color.appMuted)
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { _ in
                        AxisGridLine().foregroundStyle(Color.white.opacity(0.06))
                        AxisValueLabel().foregroundStyle(Color.appMuted)
                    }
                }
                .frame(height: 180)
            }
        }
    }

    private var daysCard: some View {
        GlassCard {
            VStack(spacing: 0) {
                HStack {
                    Text("Dni")
                        .font(.appTitle(16))
                        .foregroundStyle(Color.appWhite)
                    Spacer()
                }
                .padding(.bottom, 8)

                ForEach(Array(daysOfWeek(containing: anchor).enumerated()), id: \.element) { idx, day in
                    let entry = entries.first { $0.date.isSameDay(as: day) }
                    DayRow(day: day, entry: entry, isToday: day.isSameDay(as: Date())) {
                        editingDate = day
                    }
                    if idx < 6 {
                        Divider().overlay(Color.white.opacity(0.06))
                    }
                }
            }
        }
    }

    private func shiftWeek(_ delta: Int) {
        if let next = Calendar.iso.date(byAdding: .weekOfYear, value: delta, to: anchor) {
            anchor = next
        }
    }
}

private struct DateWrapper: Identifiable {
    let date: Date
    var id: Date { date }
}

struct MiniStat: View {
    let label: String
    let value: String
    let accent: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.appCaption(11, weight: .medium))
                .foregroundStyle(Color.appMuted)
                .textCase(.uppercase)
            Text(value)
                .font(.appNumber(16, weight: .semibold))
                .foregroundStyle(accent)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white.opacity(0.04))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        }
    }
}

struct DayRow: View {
    let day: Date
    let entry: DayEntry?
    let isToday: Bool
    var onTap: () -> Void

    private static let weekdayFmt: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "pl_PL")
        f.dateFormat = "EEE"
        return f
    }()

    private static let dayFmt: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "pl_PL")
        f.dateFormat = "d MMM"
        return f
    }()

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(Self.weekdayFmt.string(from: day).capitalized)
                        .font(.appBody(14, weight: .semibold))
                        .foregroundStyle(isToday ? Color.appGold : Color.appWhite)
                    Text(Self.dayFmt.string(from: day))
                        .font(.appCaption(11))
                        .foregroundStyle(Color.appMuted)
                }
                .frame(width: 72, alignment: .leading)

                if let entry {
                    HStack(spacing: 10) {
                        miniStat(symbol: "banknote.fill", text: entry.earnings.formattedPLN, color: .appGold)
                        miniStat(symbol: "car.fill", text: "\(entry.trips)", color: .appWhite)
                        miniStat(symbol: "clock.fill", text: entry.hoursWorked.formattedHours, color: .appWhite)
                    }
                } else {
                    Text("Brak wpisu")
                        .font(.appBody(13))
                        .foregroundStyle(Color.appMuted)
                }

                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color.appMuted)
            }
            .padding(.vertical, 10)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func miniStat(symbol: String, text: String, color: Color) -> some View {
        HStack(spacing: 4) {
            Image(systemName: symbol)
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(color)
            Text(text)
                .font(.appCaption(12, weight: .semibold))
                .foregroundStyle(Color.appWhite)
        }
    }
}
