import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    static let primaryGreen = Color(hex: "006E1A")
    static let primaryContainer = Color(hex: "28C840")
    static let primaryFixedDim = Color(hex: "4BE257")
    static let primaryFixed = Color(hex: "71FF74")

    static let secondaryBlue = Color(hex: "0058BC")
    static let secondaryFixedDim = Color(hex: "ADC6FF")

    static let surfaceDark = Color(hex: "1A1B1F")
    static let surfaceContainerHigh = Color(hex: "292A30")

    static let grass0 = Color.white.opacity(0.06)
    static let grass1 = Color(hex: "004D0F")
    static let grass2 = Color(hex: "006E1A")
    static let grass3 = Color(hex: "28C840")
    static let grass4 = Color(hex: "71FF74")
}
