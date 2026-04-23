import SwiftUI

struct GoalsView: View {
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 4) {
                Text("Cele")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                Text("Twoje postępy finansowe")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
        }
    }
}

#Preview {
    GoalsView()
}
