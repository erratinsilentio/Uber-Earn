import SwiftUI
import SwiftData

// WIP placeholder. Full implementation pending.
struct ExpensesSheet: View {
    @Environment(\.dismiss) private var dismiss
    let weekOf: Date

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackdrop()
                VStack(spacing: 16) {
                    Image(systemName: "creditcard.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(Color.appGold)
                    Text("Zarządzanie wydatkami")
                        .font(.appTitle(20))
                        .foregroundStyle(Color.appWhite)
                    Text("W przygotowaniu")
                        .font(.appBody(14))
                        .foregroundStyle(Color.appMuted)
                }
                .padding()
            }
            .navigationTitle("Wydatki")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Zamknij") { dismiss() }
                        .foregroundStyle(Color.appGold)
                }
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}
