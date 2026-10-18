import SwiftUI

extension AppTheme {
    public func isDark(colorScheme: ColorScheme) -> Bool {
        switch self {
        case .auto:
            return colorScheme == .dark
        case .liquidDark:
            return true
        case .liquidLight:
            return false
        }
    }

    public func backgroundColor(isDark: Bool) -> Color {
        return isDark ? Color(hex: "0B0F17") : Color(hex: "F8FAFC")
    }

    public func headerBackgroundColor(isDark: Bool) -> Color {
        return isDark ? Color(hex: "131A26").opacity(0.85) : Color.white.opacity(0.88)
    }

    public func cardBackgroundColor(isDark: Bool) -> Color {
        return isDark ? Color(hex: "151D2A").opacity(0.88) : Color.white
    }

    public func textColor(isDark: Bool) -> Color {
        return isDark ? .white : Color(hex: "0F172A")
    }

    public func secondaryTextColor(isDark: Bool) -> Color {
        return isDark ? Color(hex: "94A3B8") : Color(hex: "64748B")
    }

    public func strokeColor(isDark: Bool) -> Color {
        return isDark ? Color.white.opacity(0.12) : Color(hex: "E2E8F0")
    }

    public func grassColor(for level: Int, isDark: Bool) -> Color {
        if isDark {
            switch level {
            case 1: return Color(hex: "065F46")
            case 2: return Color(hex: "059669")
            case 3: return Color(hex: "10B981")
            case 4: return Color(hex: "34D399")
            default: return Color.white.opacity(0.10)
            }
        } else {
            switch level {
            case 1: return Color(hex: "A7F3D0") // Emerald-200
            case 2: return Color(hex: "6EE7B7") // Emerald-300
            case 3: return Color(hex: "34D399") // Emerald-400
            case 4: return Color(hex: "059669") // Emerald-600
            default: return Color(hex: "E2E8F0") // Slate-200
            }
        }
    }

    public func grassBorderColor(for level: Int, isDark: Bool) -> Color {
        if isDark {
            return level == 0 ? Color.white.opacity(0.08) : Color.white.opacity(0.20)
        } else {
            return level == 0 ? Color(hex: "CBD5E1") : Color(hex: "059669").opacity(0.2)
        }
    }
}
