import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(AppState.self) var appState
    @State private var showingAddEntry = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        WeekNavigatorView()

                        DayEntryChildView(
                            start: appState.weekInterval.start,
                            end: appState.weekInterval.end
                        )
                    }
                    .padding()
                }
            }
            .navigationTitle("Przegląd")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color.appBackground, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddEntry = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(Color.accent)
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $showingAddEntry) {
                DayEntryFormView()
            }
        }
    }
}

#Preview {
    DashboardView()
        .environment(AppState())
        .modelContainer(for: [DayEntry.self, Goal.self], inMemory: true)
}
