import SwiftUI
import SwiftData

struct GoalCardView: View {
    @Environment(\.modelContext) private var modelContext
    let goal: Goal
    let currentAmount: Double

    private var progress: Double {
        guard goal.targetAmount > 0 else { return 0 }
        return min(currentAmount / goal.targetAmount, 1)
    }

    private var typeLabel: String {
        switch goal.type {
        case "weekly": return "Tygodniowy"
        case "monthly": return "Miesięczny"
        default: return "Jednorazowy"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.name)
                        .font(.headline)
                        .foregroundStyle(.white)
                    Text(typeLabel)
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.white.opacity(0.08))
                        .clipShape(Capsule())
                }
                Spacer()
                PercentBadgeView(percent: Int(progress * 100))
            }

            ProgressBarView(progress: progress, tint: .accent)

            HStack {
                Text(currentAmount.formattedPLN)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                Spacer()
                Text("z \(goal.targetAmount.formattedPLN)")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
        }
        .padding()
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .swipeActions(edge: .trailing) {
            Button {
                goal.isArchived = true
            } label: {
                Label("Archiwizuj", systemImage: "archivebox")
            }
            .tint(.gray)
        }
    }
}
