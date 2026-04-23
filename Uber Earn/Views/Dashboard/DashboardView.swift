import SwiftUI

struct DashboardView: View {
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 4) {
                Text("Przegląd")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                Text("Śledź swoje zarobki")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
        }
    }
}

#Preview {
    DashboardView()
}
