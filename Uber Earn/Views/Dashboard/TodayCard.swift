import SwiftUI

struct TodayCard: View {
    let entry: DayEntry?
    var onEdit: () -> Void

    var body: some View {
        GlassCard(tint: .appGold) {
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Dzisiaj")
                            .font(.appCaption(12, weight: .semibold))
                            .foregroundStyle(Color.appMuted)
                            .textCase(.uppercase)
                        Text(entry == nil ? "Brak wpisu" : "Twoja zmiana")
                            .font(.appTitle(18))
                            .foregroundStyle(Color.appWhite)
                    }
                    Spacer()
                    Button(action: onEdit) {
                        Label(entry == nil ? "Dodaj" : "Edytuj", systemImage: entry == nil ? "plus" : "pencil")
                            .font(.appBody(14, weight: .semibold))
                            .foregroundStyle(Color.black)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 9)
                            .background {
                                Capsule().fill(LinearGradient.goldSheen)
                            }
                    }
                    .buttonStyle(.plain)
                }

                HStack(spacing: 14) {
                    StatTile(
                        label: "Zarobek",
                        value: (entry?.earnings ?? 0).formattedPLN,
                        symbol: "banknote.fill",
                        accent: .appGold
                    )
                    StatTile(
                        label: "Przejazdy",
                        value: "\(entry?.trips ?? 0)",
                        symbol: "car.fill",
                        accent: .appWhite
                    )
                    StatTile(
                        label: "Godziny",
                        value: (entry?.hoursWorked ?? 0).formattedHours,
                        symbol: "clock.fill",
                        accent: .appWhite
                    )
                }

                if let entry, entry.hoursWorked > 0 {
                    HStack(spacing: 6) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 11))
                        Text(String(format: "Średnio %@/h", entry.hourlyRate.formattedPLN))
                            .font(.appCaption(12, weight: .medium))
                    }
                    .foregroundStyle(Color.appGold)
                }
            }
        }
    }
}

struct StatTile: View {
    let label: String
    let value: String
    let symbol: String
    let accent: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: symbol)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(accent)
            Text(value)
                .font(.appNumber(18, weight: .semibold))
                .foregroundStyle(Color.appWhite)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(label)
                .font(.appCaption(11))
                .foregroundStyle(Color.appMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 12)
        .padding(.horizontal, 12)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.04))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        }
    }
}
