import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        appearance.backgroundColor = UIColor(Color.appBackground.opacity(0.6))
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem { Label("Przegląd", systemImage: "sparkles") }
                .tag(0)

            StatsView()
                .tabItem { Label("Statystyki", systemImage: "chart.bar.fill") }
                .tag(1)

            GoalsView()
                .tabItem { Label("Cele", systemImage: "target") }
                .tag(2)
        }
        .tint(Color.appGold)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [DayEntry.self, Expense.self, Goal.self], inMemory: true)
}
