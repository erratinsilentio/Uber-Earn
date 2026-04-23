import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem { Text("Przegląd") }
                .tag(0)

            ExpensesView()
                .tabItem { Text("Wydatki") }
                .tag(1)

            GoalsView()
                .tabItem { Text("Cele") }
                .tag(2)
        }
        .tint(.accent)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
