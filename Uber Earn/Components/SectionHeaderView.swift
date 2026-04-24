import SwiftUI

struct SectionHeaderView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.caption)
            .foregroundStyle(.gray)
            .textCase(.uppercase)
            .kerning(0.8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
    }
}

#Preview {
    VStack {
        SectionHeaderView(title: "Dni tygodnia")
        SectionHeaderView(title: "Suma wydatków")
    }
    .padding()
    .background(Color.appBackground)
}
