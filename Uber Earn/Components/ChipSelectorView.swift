import SwiftUI

struct ChipSelectorView: View {
    let options: [String]
    @Binding var selected: String

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(options, id: \.self) { option in
                    Button(option) { selected = option }
                        .font(.subheadline.weight(.medium))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(selected == option ? Color.accent : Color.white.opacity(0.08))
                        .foregroundStyle(selected == option ? Color.black : Color.white)
                        .clipShape(Capsule())
                }
            }
            .padding(.vertical, 4)
        }
    }
}
