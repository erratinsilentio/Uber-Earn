import SwiftUI
import SwiftData

struct GoalFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    private let typeLabels = ["Tygodniowy", "Miesięczny", "Jednorazowy"]
    private let labelToType = ["Tygodniowy": "weekly", "Miesięczny": "monthly", "Jednorazowy": "oneTime"]

    @State private var name: String = ""
    @State private var selectedTypeLabel = "Tygodniowy"
    @State private var targetAmount: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()

                Form {
                    Section("Nazwa celu") {
                        TextField("np. Tygodniowy przychód", text: $name)
                            .foregroundStyle(.white)
                    }
                    .listRowBackground(Color.cardBackground)

                    Section("Typ") {
                        ChipSelectorView(options: typeLabels, selected: $selectedTypeLabel)
                    }
                    .listRowBackground(Color.cardBackground)

                    Section("Kwota docelowa") {
                        TextField("Kwota (zł)", text: $targetAmount)
                            .keyboardType(.decimalPad)
                            .foregroundStyle(.white)
                    }
                    .listRowBackground(Color.cardBackground)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Nowy cel")
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
                        .disabled(name.isEmpty || targetAmount.isEmpty)
                }
            }
        }
    }

    private func save() {
        let amount = Double(targetAmount.replacingOccurrences(of: ",", with: ".")) ?? 0
        let type = labelToType[selectedTypeLabel] ?? "weekly"
        modelContext.insert(Goal(name: name, type: type, targetAmount: amount))
        dismiss()
    }
}

#Preview {
    GoalFormView()
        .modelContainer(for: Goal.self, inMemory: true)
}
