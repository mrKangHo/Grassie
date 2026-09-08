import Foundation

public protocol ManageSettingsUseCaseProtocol: AnyObject {
    var settings: SettingsRepositoryProtocol { get }
}

public final class ManageSettingsUseCase: ManageSettingsUseCaseProtocol {
    public let settings: SettingsRepositoryProtocol

    public init(settings: SettingsRepositoryProtocol) {
        self.settings = settings
    }
}
