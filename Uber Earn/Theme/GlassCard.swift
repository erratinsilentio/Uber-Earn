import SwiftUI

struct GlassCard<Content: View>: View {
    var padding: CGFloat = 20
    var cornerRadius: CGFloat = 24
    var tint: Color = .white
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(.ultraThinMaterial)
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    tint.opacity(0.06),
                                    tint.opacity(0.015),
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(LinearGradient.glassStroke, lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.35), radius: 18, x: 0, y: 10)
    }
}

struct AppBackdrop: View {
    var body: some View {
        ZStack {
            LinearGradient.appBackdrop.ignoresSafeArea()
            // Subtle gold glow for depth
            RadialGradient(
                colors: [Color.appGold.opacity(0.18), .clear],
                center: .topTrailing,
                startRadius: 40,
                endRadius: 420
            )
            .ignoresSafeArea()
            .blendMode(.plusLighter)
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.appBody(16, weight: .semibold))
            .foregroundStyle(Color.black)
            .padding(.vertical, 14)
            .padding(.horizontal, 22)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(LinearGradient.goldSheen)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
            }
            .opacity(configuration.isPressed ? 0.85 : 1)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}

struct GhostButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.appBody(15, weight: .semibold))
            .foregroundStyle(Color.appText)
            .padding(.vertical, 12)
            .padding(.horizontal, 18)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(.ultraThinMaterial)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            }
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}
