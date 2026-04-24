import SwiftUI

// Brief wants Poppins; we use rounded system as a stand-in until the font
// file is bundled. Swap `design: .rounded` for `.custom("Poppins-…", size:)`
// once the Poppins family is added to the target.
extension Font {
    static func appDisplay(_ size: CGFloat = 34) -> Font {
        .system(size: size, weight: .bold, design: .rounded)
    }

    static func appTitle(_ size: CGFloat = 22) -> Font {
        .system(size: size, weight: .semibold, design: .rounded)
    }

    static func appNumber(_ size: CGFloat, weight: Font.Weight = .bold) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }

    static func appBody(_ size: CGFloat = 16, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }

    static func appCaption(_ size: CGFloat = 12, weight: Font.Weight = .medium) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }
}
