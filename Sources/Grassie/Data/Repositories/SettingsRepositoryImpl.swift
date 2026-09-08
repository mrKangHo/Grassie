import Foundation

public final class SettingsRepositoryImpl: SettingsRepositoryProtocol {
    private let dataSource: UserDefaultsSettingsDataSource

    public init(dataSource: UserDefaultsSettingsDataSource = UserDefaultsSettingsDataSource()) {
        self.dataSource = dataSource
    }

    public var username: String {
        get { dataSource.username }
        set { dataSource.username = newValue }
    }

    public var theme: AppTheme {
        get { dataSource.theme }
        set { dataSource.theme = newValue }
    }

    public var language: AppLanguage {
        get { dataSource.language }
        set { dataSource.language = newValue }
    }

    public var autoLaunchEnabled: Bool {
        get { dataSource.autoLaunchEnabled }
        set { dataSource.autoLaunchEnabled = newValue }
    }

    public var refreshIntervalMinutes: Int {
        get { dataSource.refreshIntervalMinutes }
        set { dataSource.refreshIntervalMinutes = newValue }
    }
}
