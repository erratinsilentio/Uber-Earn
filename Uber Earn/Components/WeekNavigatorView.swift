import SwiftUI

struct WeekNavigatorView: View {
    @Environment(AppState.self) var appState

    var body: some View {
        HStack {
            Button {
                appState.goToPreviousWeek()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
            }

            Spacer()

            VStack(spacing: 2) {
                if appState.isCurrentWeek {
                    Text("Ten tydzień")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                Text(appState.weekLabel)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white)
            }

            Spacer()

            Button {
                appState.goToNextWeek()
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    WeekNavigatorView()
        .environment(AppState())
        .padding()
        .background(Color.appBackground)
}
