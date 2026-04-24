import SwiftUI
import SwiftData
import UIKit

struct EditDayEntrySheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let date: Date
    let existing: DayEntry?

    @State private var earnings: String = ""
    @State private var trips: String = ""
    @State private var hours: String = ""
    @State private var note: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackdrop()
                ScrollView {
                    VStack(spacing: 18) {
                        GlassCard(tint: .appGold) {
                            VStack(alignment: .leading, spacing: 16) {
                                Text(dateHeadline)
                                    .font(.appTitle(18))
                                    .foregroundStyle(Color.appWhite)

                                FieldRow(
                                    label: "Zarobek",
                                    suffix: "zł",
                                    text: $earnings,
                                    keyboard: .decimalPad,
                                    symbol: "banknote.fill"
                                )
                                FieldRow(
                                    label: "Przejazdy",
                                    suffix: "",
                                    text: $trips,
                                    keyboard: .numberPad,
                                    symbol: "car.fill"
                                )
                                FieldRow(
                                    label: "Godziny pracy",
                                    suffix: "h",
                                    text: $hours,
                                    keyboard: .decimalPad,
                                    symbol: "clock.fill"
                                )
                            }
                        }

                        GlassCard {
                            VStack(alignment: .leading, spacing: 10) {
                                Label("Notatka", systemImage: "square.and.pencil")
                                    .font(.appCaption(12, weight: .semibold))
                                    .foregroundStyle(Color.appMuted)
                                    .textCase(.uppercase)
                                TextField("Opcjonalnie", text: $note, axis: .vertical)
                                    .font(.appBody(15))
                                    .foregroundStyle(Color.appWhite)
                                    .lineLimit(3...6)
                            }
                        }

                        Button(action: save) {
                            Text(existing == nil ? "Zapisz wpis" : "Zapisz zmiany")
                        }
                        .buttonStyle(PrimaryButtonStyle())

                        if existing != nil {
                            Button(role: .destructive, action: deleteEntry) {
                                Label("Usuń wpis", systemImage: "trash")
                                    .foregroundStyle(Color.appDanger)
                            }
                            .buttonStyle(GhostButtonStyle())
                        }
                    }
                    .padding(18)
                }
            }
            .navigationTitle("Zmiana")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Anuluj") { dismiss() }
                        .foregroundStyle(Color.appGold)
                }
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
            .onAppear(perform: populate)
        }
    }

    private var dateHeadline: String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "pl_PL")
        f.dateFormat = "EEEE, d MMMM"
        return f.string(from: date).capitalized
    }

    private func populate() {
        guard let existing else { return }
        earnings = existing.earnings > 0 ? trim(existing.earnings) : ""
        trips = existing.trips > 0 ? "\(existing.trips)" : ""
        hours = existing.hoursWorked > 0 ? trim(existing.hoursWorked) : ""
        note = existing.note
    }

    private func save() {
        let e = parseDouble(earnings)
        let t = Int(trips) ?? 0
        let h = parseDouble(hours)

        if let existing {
            existing.earnings = e
            existing.trips = t
            existing.hoursWorked = h
            existing.note = note
        } else {
            let entry = DayEntry(date: date, trips: t, hoursWorked: h, earnings: e, note: note)
            modelContext.insert(entry)
        }
        try? modelContext.save()
        dismiss()
    }

    private func deleteEntry() {
        if let existing {
            modelContext.delete(existing)
            try? modelContext.save()
        }
        dismiss()
    }

    private func parseDouble(_ s: String) -> Double {
        Double(s.replacingOccurrences(of: ",", with: ".")) ?? 0
    }

    private func trim(_ v: Double) -> String {
        if v.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(v))
        }
        return String(format: "%.2f", v).replacingOccurrences(of: ".", with: ",")
    }
}

struct FieldRow: View {
    let label: String
    let suffix: String
    @Binding var text: String
    let keyboard: UIKeyboardType
    let symbol: String

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(Color.appGold.opacity(0.15)).frame(width: 36, height: 36)
                Image(systemName: symbol)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.appGold)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.appCaption(11, weight: .medium))
                    .foregroundStyle(Color.appMuted)
                    .textCase(.uppercase)
                HStack {
                    TextField("0", text: $text)
                        .keyboardType(keyboard)
                        .font(.appNumber(18, weight: .semibold))
                        .foregroundStyle(Color.appWhite)
                    if !suffix.isEmpty {
                        Text(suffix)
                            .font(.appBody(14))
                            .foregroundStyle(Color.appMuted)
                    }
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white.opacity(0.04))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        }
    }
}
