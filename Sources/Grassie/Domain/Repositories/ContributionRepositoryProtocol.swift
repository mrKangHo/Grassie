import Foundation

public protocol ContributionRepositoryProtocol: Sendable {
    func fetchContributions(username: String, completion: @escaping (Result<GitHubContributionData, Error>) -> Void)
}
