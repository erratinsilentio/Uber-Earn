import SwiftUI
import SwiftData

struct DayEntryFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var entry: DayEntry? = nil  // nil = new entry

    @State private var date: Date = .now
    @State private var startTime: Date = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: .now)!
    @State private var endTime: Date = Calendar.current.date(bySettingHour: 13, minute: 30, second: 0, of: .now)!
    @State private var earnings: String = ""
    @State private var trips: String = ""
    @State private var note: String = ""
    @State private var showTimeError = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()

                Form {
                    Section {
                        DatePicker("Data", selection: $date, displayedComponents: .date)
                            .foregroundStyle(.white)
                    }
                    .listRowBackground(Color.cardBackground)

                    Section {
                        DatePicker("Początek", selection: $startTime, displayedComponents: .hourAndMinute)
                            .foregroundStyle(.white)
                        DatePicker("Koniec", selection: $endTime, displayedComponents: .hourAndMinute)
                            .foregroundStyle(.white)
                        if showTimeError {
                            Text("Czas zakończenia musi być późniejszy niż początek.")
                                .font(.caption)
                                .foregroundStyle(Color.expenseRed)
                        }
                    }
                    .listRowBackground(Color.cardBackground)

                    Section {
                        TextField("Zarobki (zł)", text: $earnings)
                            .keyboardType(.decimalPad)
                            .foregroundStyle(.white)
                        TextField("Liczba kursów", text: $trips)
                            .keyboardType(.numberPad)
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
            .navigationTitle(entry == nil ? "Nowy dzień" : "Edytuj dzień")
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
        .onAppear { populateIfEditing() }
    }

    private func populateIfEditing() {
        guard let entry else { return }
        date = entry.date
        startTime = entry.startTime
        endTime = entry.endTime
        earnings = String(entry.earnings)
        trips = String(entry.trips)
        note = entry.note
    }

    private func save() {
        guard endTime > startTime else {
            showTimeError = true
            return
        }
        let amount = Double(earnings.replacingOccurrences(of: ",", with: ".")) ?? 0
        let tripCount = Int(trips) ?? 0

        if let entry {
            entry.date = date
            entry.startTime = startTime
            entry.endTime = endTime
            entry.earnings = amount
            entry.trips = tripCount
            entry.note = note
        } else {
            let newEntry = DayEntry(
                date: date,
                startTime: startTime,
                endTime: endTime,
                earnings: amount,
                trips: tripCount,
                note: note
            )
            modelContext.insert(newEntry)
        }
        dismiss()
    }
}

#Preview {
    DayEntryFormView()
        .modelContainer(for: DayEntry.self, inMemory: true)
}
