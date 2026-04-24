import SwiftUI

struct MetricCardView: View {
    let title: String
    let value: String
    let valueColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.gray)
                .textCase(.uppercase)
                .kerning(0.5)

            Text(value)
                .font(.title2.weight(.bold))
                .foregroundStyle(valueColor)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
        MetricCardView(title: "Przychód", value: "1 574 zł", valueColor: .accent)
        MetricCardView(title: "Wydatki", value: "435 zł", valueColor: .expenseRed)
        MetricCardView(title: "Zysk netto", value: "1 139 zł", valueColor: .white)
        MetricCardView(title: "Stawka godz.", value: "42 zł/h", valueColor: .white)
    }
    .padding()
    .background(Color.appBackground)
}
