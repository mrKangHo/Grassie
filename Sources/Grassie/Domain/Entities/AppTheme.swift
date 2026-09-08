import Foundation

public enum AppTheme: String, CaseIterable, Identifiable, Sendable {
    case auto = "System Auto"
    case liquidDark = "Liquid Dark"
    case liquidLight = "Liquid Light"

    public var id: String { self.rawValue }

    public var labelKey: String {
        switch self {
        case .auto: return "system_auto"
        case .liquidDark: return "liquid_dark"
        case .liquidLight: return "liquid_light"
        }
    }
}
