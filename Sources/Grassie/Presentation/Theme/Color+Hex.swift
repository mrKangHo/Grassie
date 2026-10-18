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

    // MARK: - Stitch Modern Light / Dark Tokens
    static let stitchSurfaceBase = Color(hex: "F8FAFC")
    static let stitchSurfaceSubtle = Color(hex: "F1F5F9")
    static let stitchSurfaceCard = Color(hex: "FFFFFF")
    static let stitchSurfaceBorder = Color(hex: "E2E8F0")

    static let stitchIndigo = Color(hex: "4F46E5")
    static let stitchBlue = Color(hex: "2563EB")
    static let stitchEmerald = Color(hex: "10B981")
    static let stitchGrass = Color(hex: "059669")

    static let stitchAmber50 = Color(hex: "FFFBEB")
    static let stitchAmber200 = Color(hex: "FDE68A")
    static let stitchAmber500 = Color(hex: "F59E0B")
    static let stitchAmber700 = Color(hex: "B45309")
    static let stitchOrange500 = Color(hex: "F97316")

    static let stitchSlate900 = Color(hex: "0F172A")
    static let stitchSlate800 = Color(hex: "1E293B")
    static let stitchSlate700 = Color(hex: "334155")
    static let stitchSlate600 = Color(hex: "475569")
    static let stitchSlate500 = Color(hex: "64748B")
    static let stitchSlate400 = Color(hex: "94A3B8")
    static let stitchSlate300 = Color(hex: "CBD5E1")
    static let stitchSlate200 = Color(hex: "E2E8F0")
    static let stitchSlate100 = Color(hex: "F1F5F9")
    static let stitchSlate50 = Color(hex: "F8FAFC")

    static let stitchEmerald200 = Color(hex: "A7F3D0")
    static let stitchEmerald300 = Color(hex: "6EE7B7")
    static let stitchEmerald400 = Color(hex: "34D399")
    static let stitchEmerald500 = Color(hex: "10B981")
    static let stitchEmerald600 = Color(hex: "059669")
}
