import SwiftUI

struct ProgressBarView: View {
    let progress: Double  // clamped 0–1
    let tint: Color

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 6)

                Capsule()
                    .fill(tint)
                    .frame(width: geo.size.width * min(max(progress, 0), 1), height: 6)
            }
        }
        .frame(height: 6)
    }
}

#Preview {
    VStack(spacing: 16) {
        ProgressBarView(progress: 0.74, tint: .accent)
        ProgressBarView(progress: 0.3, tint: .accent)
        ProgressBarView(progress: 1.0, tint: .accent)
    }
    .padding()
    .background(Color.appBackground)
}
