import SwiftUI

struct WeekSummaryCard: View {
    let earnings: Double
    let expenses: Double
    let trips: Int
    let hours: Double
    var onManageExpenses: () -> Void

    private var balance: Double { earnings - expenses }

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Ten tydzień")
                            .font(.appCaption(12, weight: .semibold))
                            .foregroundStyle(Color.appMuted)
                            .textCase(.uppercase)
                        Text("Saldo")
                            .font(.appTitle(18))
                            .foregroundStyle(Color.appWhite)
                    }
                    Spacer()
                    balancePill
                }

                Text(balance.formattedPLN)
                    .font(.appDisplay(40))
                    .foregroundStyle(
                        balance >= 0 ? AnyShapeStyle(LinearGradient.goldSheen) : AnyShapeStyle(Color.appDanger)
                    )
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)

                Divider().overlay(Color.white.opacity(0.08))

                VStack(spacing: 12) {
                    SummaryRow(label: "Zarobki", value: earnings.formattedPLN, symbol: "arrow.up.right", color: .appGold)
                    SummaryRow(label: "Wydatki", value: expenses.formattedPLN, symbol: "arrow.down.right", color: .appDanger)
                    SummaryRow(label: "Przejazdy", value: "\(trips)", symbol: "car.fill", color: .appWhite)
                    SummaryRow(label: "Godziny pracy", value: hours.formattedHours, symbol: "clock.fill", color: .appWhite)
                }

                Button(action: onManageExpenses) {
                    Label("Zarządzaj wydatkami", systemImage: "creditcard.fill")
                }
                .buttonStyle(GhostButtonStyle())
            }
        }
    }

    private var balancePill: some View {
        HStack(spacing: 6) {
            Image(systemName: balance >= 0 ? "arrow.up.forward" : "arrow.down.forward")
                .font(.system(size: 10, weight: .bold))
            Text(balance >= 0 ? "Na plusie" : "Na minusie")
                .font(.appCaption(11, weight: .semibold))
        }
        .foregroundStyle(balance >= 0 ? Color.appGold : Color.appDanger)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background {
            Capsule()
                .fill((balance >= 0 ? Color.appGold : Color.appDanger).opacity(0.12))
        }
    }
}

struct SummaryRow: View {
    let label: String
    let value: String
    let symbol: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(color.opacity(0.14)).frame(width: 30, height: 30)
                Image(systemName: symbol)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(color)
            }
            Text(label)
                .font(.appBody(14))
                .foregroundStyle(Color.appText)
            Spacer()
            Text(value)
                .font(.appNumber(15, weight: .semibold))
                .foregroundStyle(Color.appWhite)
        }
    }
}
