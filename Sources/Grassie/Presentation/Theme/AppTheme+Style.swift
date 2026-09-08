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
        return isDark ? Color(hex: "0E1014").opacity(0.92) : Color(hex: "F2F4F8")
    }

    public func headerBackgroundColor(isDark: Bool) -> Color {
        return isDark ? Color.black.opacity(0.45) : Color.white.opacity(0.85)
    }

    public func cardBackgroundColor(isDark: Bool) -> Color {
        return isDark ? Color.black.opacity(0.35) : Color.white
    }

    public func textColor(isDark: Bool) -> Color {
        return isDark ? .white : Color(hex: "111318")
    }

    public func secondaryTextColor(isDark: Bool) -> Color {
        return isDark ? Color.white.opacity(0.85) : Color(hex: "111318").opacity(0.75)
    }

    public func strokeColor(isDark: Bool) -> Color {
        return isDark ? Color.white.opacity(0.22) : Color.black.opacity(0.12)
    }

    public func grassColor(for level: Int, isDark: Bool) -> Color {
        if isDark {
            switch level {
            case 1: return Color(hex: "0E4429")
            case 2: return Color(hex: "006E1A")
            case 3: return Color(hex: "28C840")
            case 4: return Color(hex: "71FF74")
            default: return Color.white.opacity(0.12)
            }
        } else {
            switch level {
            case 1: return Color(hex: "9BE9A8")
            case 2: return Color(hex: "40C463")
            case 3: return Color(hex: "30A14E")
            case 4: return Color(hex: "216E39")
            default: return Color(hex: "EBEDF0")
            }
        }
    }

    public func grassBorderColor(for level: Int, isDark: Bool) -> Color {
        if isDark {
            return level == 0 ? Color.white.opacity(0.18) : Color.white.opacity(0.3)
        } else {
            return level == 0 ? Color.black.opacity(0.08) : Color.black.opacity(0.2)
        }
    }
}
