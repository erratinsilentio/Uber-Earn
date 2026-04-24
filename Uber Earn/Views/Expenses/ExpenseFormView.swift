import SwiftUI
import SwiftData

struct ExpenseFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    private let categories = ["Paliwo", "Myjnia", "Serwis", "Inne"]

    @State private var selectedCategory = "Paliwo"
    @State private var amount: String = ""
    @State private var date: Date = .now
    @State private var note: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()

                Form {
                    Section("Kategoria") {
                        ChipSelectorView(options: categories, selected: $selectedCategory)
                    }
                    .listRowBackground(Color.cardBackground)

                    Section {
                        TextField("Kwota (zł)", text: $amount)
                            .keyboardType(.decimalPad)
                            .foregroundStyle(.white)
                        DatePicker("Data", selection: $date, displayedComponents: .date)
                            .foregroundStyle(.white)
                    }
                    .listRowBackground(Color.cardBackground)

                    Section {
                        TextField("Notatka (opcjonalnie)", text: $note)
                            .foregroundStyle(.white)
                    }
                    .listRowBackground(Color.cardBackground)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Nowy wydatek")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.appBackground, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Anuluj") { dismiss() }
                        .foregroundStyle(.gray)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Zapisz") { save() }
                        .foregroundStyle(Color.accent)
                        .fontWeight(.semibold)
                }
            }
        }
    }

    private func save() {
        let value = Double(amount.replacingOccurrences(of: ",", with: ".")) ?? 0
        modelContext.insert(Expense(date: date, category: selectedCategory, amount: value, note: note))
        dismiss()
    }
}

#Preview {
    ExpenseFormView()
        .modelContainer(for: Expense.self, inMemory: true)
}
