import Foundation

public enum AppLanguage: String, CaseIterable, Identifiable, Sendable {
    case en = "English"
    case ko = "한국어"
    case ja = "日本語"
    case zh = "中文"

    public var id: String { self.rawValue }

    public var displayName: String {
        return self.rawValue
    }

    public static var systemDefault: AppLanguage {
        let preferred = Locale.preferredLanguages.first?.lowercased() ?? "en"
        if preferred.hasPrefix("ko") {
            return .ko
        } else if preferred.hasPrefix("ja") {
            return .ja
        } else if preferred.hasPrefix("zh") {
            return .zh
        } else {
            return .en
        }
    }
}
