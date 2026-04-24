import SwiftUI

struct GoalProgressCard: View {
    let goal: Goal
    let weekEarnings: Double
    let weekTrips: Int
    let today: Date

    private var currentValue: Double {
        switch goal.metricValue {
        case .earnings: weekEarnings
        case .trips: Double(weekTrips)
        }
    }

    private var progress: Double {
        guard goal.target > 0 else { return 0 }
        return min(1, currentValue / goal.target)
    }

    private var remaining: Double {
        max(0, goal.target - currentValue)
    }

    private var remainingDays: Int {
        guard goal.isActive(on: today) else { return 0 }
        let todayStart = today.startOfDay
        let end = goal.weekEnd.startOfDay
        let comps = Calendar.iso.dateComponents([.day], from: todayStart, to: end)
        return max(0, (comps.day ?? 0) + 1)
    }

    private var dailyTarget: Double {
        guard remainingDays > 0 else { return remaining }
        return remaining / Double(remainingDays)
    }

    var body: some View {
        GlassCard(tint: .appGold) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Cel tygodnia")
                            .font(.appCaption(12, weight: .semibold))
                            .foregroundStyle(Color.appMuted)
                            .textCase(.uppercase)
                        Text(goal.name)
                            .font(.appTitle(18))
                            .foregroundStyle(Color.appWhite)
                    }
                    Spacer()
                    ProgressRing(progress: progress)
                        .frame(width: 64, height: 64)
                }

                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(progressLabel)
                        .font(.appDisplay(32))
                        .foregroundStyle(LinearGradient.goldSheen)
                    Text("z \(targetLabel)")
                        .font(.appBody(14))
                        .foregroundStyle(Color.appMuted)
                }

                if progress >= 1 {
                    doneBadge
                } else if remainingDays == 0 {
                    missedBadge
                } else {
                    paceBlock
                }
            }
        }
    }

    private var progressLabel: String {
        switch goal.metricValue {
        case .earnings: currentValue.formattedPLN
        case .trips: "\(Int(currentValue))"
        }
    }

    private var targetLabel: String {
        switch goal.metricValue {
        case .earnings: goal.target.formattedPLN
        case .trips: "\(Int(goal.target))"
        }
    }

    private var doneBadge: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.seal.fill")
                .foregroundStyle(Color.appGold)
            Text("Cel zrealizowany. Dobra robota.")
                .font(.appBody(14, weight: .semibold))
                .foregroundStyle(Color.appWhite)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.appGold.opacity(0.12))
        }
    }

    private var missedBadge: some View {
        HStack(spacing: 8) {
            Image(systemName: "clock.badge.exclamationmark.fill")
                .foregroundStyle(Color.appDanger)
            Text("Tydzień się kończy – brakuje \(remainingLabel).")
                .font(.appBody(14, weight: .semibold))
                .foregroundStyle(Color.appWhite)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.appDanger.opacity(0.12))
        }
    }

    private var paceBlock: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                paceChip(
                    icon: "calendar",
                    title: "Zostało",
                    value: "\(remainingDays) \(remainingDays == 1 ? "dzień" : "dni")"
                )
                paceChip(
                    icon: "flag.fill",
                    title: "Brakuje",
                    value: remainingLabel
                )
            }
            HStack(spacing: 10) {
                Image(systemName: "bolt.fill")
                    .foregroundStyle(Color.appGold)
                Text("Aby zrealizować cel, zrób średnio **\(dailyTargetLabel)** dziennie.")
                    .font(.appBody(14))
                    .foregroundStyle(Color.appText)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.appGold.opacity(0.1))
            }
            .overlay {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color.appGold.opacity(0.28), lineWidth: 1)
            }
        }
    }

    private var remainingLabel: String {
        switch goal.metricValue {
        case .earnings: remaining.formattedPLN
        case .trips: "\(Int(remaining.rounded(.up))) przejazdów"
        }
    }

    private var dailyTargetLabel: String {
        switch goal.metricValue {
        case .earnings: dailyTarget.formattedPLN
        case .trips: "\(Int(dailyTarget.rounded(.up))) przejazdów"
        }
    }

    private func paceChip(icon: String, title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .semibold))
                Text(title)
                    .font(.appCaption(11, weight: .medium))
                    .textCase(.uppercase)
            }
            .foregroundStyle(Color.appMuted)
            Text(value)
                .font(.appNumber(16, weight: .semibold))
                .foregroundStyle(Color.appWhite)
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

struct ProgressRing: View {
    let progress: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.1), lineWidth: 6)
            Circle()
                .trim(from: 0, to: max(0.001, progress))
                .stroke(
                    LinearGradient.goldSheen,
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 0.6), value: progress)
            Text("\(Int((progress * 100).rounded()))%")
                .font(.appNumber(13, weight: .bold))
                .foregroundStyle(Color.appWhite)
        }
    }
}
