import Foundation

public struct ContributionDay: Identifiable, Sendable {
    public let id: UUID
    public let date: Date
    public let count: Int
    public let level: Int

    public init(id: UUID = UUID(), date: Date, count: Int, level: Int) {
        self.id = id
        self.date = date
        self.count = count
        self.level = level
    }
}

public struct GitHubContributionData: Sendable {
    public let days: [ContributionDay]
    public let totalContributions: Int
    public let currentStreak: Int
    public let bestDayCount: Int
    public let bestDayDate: String
    public let activeConsistency: Double

    public init(
        days: [ContributionDay],
        totalContributions: Int,
        currentStreak: Int,
        bestDayCount: Int,
        bestDayDate: String,
        activeConsistency: Double
    ) {
        self.days = days
        self.totalContributions = totalContributions
        self.currentStreak = currentStreak
        self.bestDayCount = bestDayCount
        self.bestDayDate = bestDayDate
        self.activeConsistency = activeConsistency
    }
}
