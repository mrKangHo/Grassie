import Foundation
import ServiceManagement

public final class UserDefaultsSettingsDataSource {
    private let userDefaults: UserDefaults
    private static let usernameKey = "github_username"
    private static let themeKey = "app_theme"
    private static let languageKey = "app_language"
    private static let refreshIntervalKey = "refresh_interval_minutes"
    private static let autoLaunchKey = "auto_launch_enabled"

    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    public var username: String {
        get {
            let saved = userDefaults.string(forKey: Self.usernameKey) ?? ""
            let clean = saved.trimmingCharacters(in: .whitespacesAndNewlines)
            if clean == "lee" {
                userDefaults.removeObject(forKey: Self.usernameKey)
                return ""
            }
            return clean
        }
        set {
            userDefaults.set(newValue.trimmingCharacters(in: .whitespacesAndNewlines), forKey: Self.usernameKey)
        }
    }

    public var theme: AppTheme {
        get {
            let saved = userDefaults.string(forKey: Self.themeKey) ?? "System Auto"
            return AppTheme(rawValue: saved) ?? .auto
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: Self.themeKey)
        }
    }

    public var language: AppLanguage {
        get {
            if let saved = userDefaults.string(forKey: Self.languageKey),
               let lang = AppLanguage(rawValue: saved) {
                return lang
            }
            return .systemDefault
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: Self.languageKey)
        }
    }

    public var autoLaunchEnabled: Bool {
        get {
            if #available(macOS 13.0, *) {
                let status = SMAppService.mainApp.status
                if status == .enabled {
                    return true
                }
            }
            return userDefaults.bool(forKey: Self.autoLaunchKey)
        }
        set {
            userDefaults.set(newValue, forKey: Self.autoLaunchKey)
            if #available(macOS 13.0, *) {
                do {
                    if newValue {
                        if SMAppService.mainApp.status != .enabled {
                            try SMAppService.mainApp.register()
                        }
                    } else {
                        if SMAppService.mainApp.status == .enabled {
                            try SMAppService.mainApp.unregister()
                        }
                    }
                } catch {
                    print("Failed to toggle auto launch: \(error.localizedDescription)")
                }
            }
        }
    }

    public var refreshIntervalMinutes: Int {
        get {
            let interval = userDefaults.integer(forKey: Self.refreshIntervalKey)
            return interval > 0 ? interval : 15
        }
        set {
            userDefaults.set(newValue, forKey: Self.refreshIntervalKey)
        }
    }
}
