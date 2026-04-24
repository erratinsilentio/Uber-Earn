import SwiftUI

// WIP placeholder. Full implementation pending.
struct StatsView: View {
    var body: some View {
        ZStack {
            AppBackdrop()
            VStack(alignment: .leading, spacing: 8) {
                Text("Statystyki")
                    .font(.appDisplay(32))
                    .foregroundStyle(Color.appWhite)
                Text("W przygotowaniu")
                    .font(.appBody(14))
                    .foregroundStyle(Color.appMuted)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(18)
        }
    }
}
