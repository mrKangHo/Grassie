import Foundation

public final class ContributionRepositoryImpl: ContributionRepositoryProtocol {
    private let apiService: GitHubAPIService

    public init(apiService: GitHubAPIService = .shared) {
        self.apiService = apiService
    }

    public func fetchContributions(username: String, completion: @escaping (Result<GitHubContributionData, Error>) -> Void) {
        apiService.fetchContributions(username: username, completion: completion)
    }
}
