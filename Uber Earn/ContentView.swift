import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var appState = AppState()

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem { Label("Przegląd", systemImage: "chart.bar.fill") }
                .tag(0)

            ExpensesView()
                .tabItem { Label("Wydatki", systemImage: "creditcard.fill") }
                .tag(1)

            GoalsView()
                .tabItem { Label("Cele", systemImage: "target") }
                .tag(2)
        }
        .environment(appState)
        .tint(.accent)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
