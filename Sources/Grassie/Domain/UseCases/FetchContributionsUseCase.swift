import Foundation

public protocol FetchContributionsUseCaseProtocol: Sendable {
    func execute(username: String, completion: @escaping (Result<GitHubContributionData, Error>) -> Void)
}

public final class FetchContributionsUseCase: FetchContributionsUseCaseProtocol {
    private let repository: ContributionRepositoryProtocol

    public init(repository: ContributionRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(username: String, completion: @escaping (Result<GitHubContributionData, Error>) -> Void) {
        repository.fetchContributions(username: username, completion: completion)
    }
}
