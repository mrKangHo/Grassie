import Foundation

public final class AppDIContainer: @unchecked Sendable {
    public static let shared = AppDIContainer()

    public let gitHubAPIService: GitHubAPIService
    public let settingsDataSource: UserDefaultsSettingsDataSource

    public let contributionRepository: ContributionRepositoryProtocol
    public let settingsRepository: SettingsRepositoryProtocol

    public let fetchContributionsUseCase: FetchContributionsUseCaseProtocol
    public let calculateStreakUseCase: CalculateStreakUseCaseProtocol
    public let manageSettingsUseCase: ManageSettingsUseCaseProtocol

    private init() {
        let apiService = GitHubAPIService.shared
        let settingsDS = UserDefaultsSettingsDataSource()

        self.gitHubAPIService = apiService
        self.settingsDataSource = settingsDS

        self.contributionRepository = ContributionRepositoryImpl(apiService: apiService)
        self.settingsRepository = SettingsRepositoryImpl(dataSource: settingsDS)

        self.fetchContributionsUseCase = FetchContributionsUseCase(repository: self.contributionRepository)
        self.calculateStreakUseCase = CalculateStreakUseCase()
        self.manageSettingsUseCase = ManageSettingsUseCase(settings: self.settingsRepository)
    }

    public func makeContributionViewModel() -> ContributionViewModel {
        return ContributionViewModel(
            fetchContributionsUseCase: fetchContributionsUseCase,
            calculateStreakUseCase: calculateStreakUseCase,
            settingsRepository: settingsRepository
        )
    }
}
