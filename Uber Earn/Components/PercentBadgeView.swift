import SwiftUI

struct PercentBadgeView: View {
    let percent: Int

    var body: some View {
        Text("\(percent)%")
            .font(.caption.weight(.semibold))
            .foregroundStyle(Color.accent)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(Color.accent.opacity(0.15))
            .clipShape(Capsule())
    }
}

#Preview {
    HStack {
        PercentBadgeView(percent: 74)
        PercentBadgeView(percent: 100)
        PercentBadgeView(percent: 12)
    }
    .padding()
    .background(Color.appBackground)
}
