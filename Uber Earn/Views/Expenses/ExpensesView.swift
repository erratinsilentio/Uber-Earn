import SwiftUI

struct ExpensesView: View {
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 4) {
                Text("Wydatki")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                Text("Koszty tygodniowe")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
        }
    }
}

#Preview {
    ExpensesView()
}
