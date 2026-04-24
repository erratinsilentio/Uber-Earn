import SwiftUI
import SwiftData

struct ExpensesView: View {
    @Environment(AppState.self) var appState
    @State private var showingAddExpense = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color.appBackground.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        WeekNavigatorView()

                        ExpenseChildView(
                            start: appState.weekInterval.start,
                            end: appState.weekInterval.end
                        )
                    }
                    .padding()
                    .padding(.bottom, 80)
                }

                // Add button
                Button {
                    showingAddExpense = true
                } label: {
                    Label("Dodaj wydatek", systemImage: "plus")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                }
            }
            .navigationTitle("Wydatki")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color.appBackground, for: .navigationBar)
            .sheet(isPresented: $showingAddExpense) {
                ExpenseFormView()
            }
        }
    }
}

#Preview {
    ExpensesView()
        .environment(AppState())
        .modelContainer(for: Expense.self, inMemory: true)
}
