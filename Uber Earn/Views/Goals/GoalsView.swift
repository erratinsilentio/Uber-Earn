import SwiftUI
import SwiftData

struct GoalsView: View {
    @State private var showingAddGoal = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color.appBackground.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        GoalsChildView()

                        // New goal dashed button
                        Button {
                            showingAddGoal = true
                        } label: {
                            HStack {
                                Image(systemName: "plus")
                                Text("Nowy cel")
                                    .font(.subheadline.weight(.medium))
                            }
                            .foregroundStyle(Color.accent)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [6]))
                                    .foregroundStyle(Color.accent.opacity(0.5))
                            )
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Cele")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color.appBackground, for: .navigationBar)
            .sheet(isPresented: $showingAddGoal) {
                GoalFormView()
            }
        }
    }
}

#Preview {
    GoalsView()
        .modelContainer(for: [Goal.self, DayEntry.self], inMemory: true)
}
