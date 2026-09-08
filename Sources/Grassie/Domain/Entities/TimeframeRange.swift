import Foundation

public enum TimeframeRange: String, CaseIterable, Identifiable, Sendable {
    case oneMonth = "1M"
    case threeMonths = "3M"
    case sixMonths = "6M"
    case oneYear = "1Y"

    public var id: String { self.rawValue }

    public func label(language: AppLanguage) -> String {
        switch self {
        case .oneMonth: return L10n.string("last_1_month", language: language)
        case .threeMonths: return L10n.string("last_3_months", language: language)
        case .sixMonths: return L10n.string("last_6_months", language: language)
        case .oneYear: return L10n.string("last_1_year", language: language)
        }
    }
}
