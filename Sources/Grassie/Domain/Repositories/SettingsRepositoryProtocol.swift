import Foundation

public protocol SettingsRepositoryProtocol: AnyObject {
    var username: String { get set }
    var theme: AppTheme { get set }
    var language: AppLanguage { get set }
    var autoLaunchEnabled: Bool { get set }
    var refreshIntervalMinutes: Int { get set }
}
