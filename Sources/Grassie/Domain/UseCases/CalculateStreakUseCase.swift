import Foundation

public protocol CalculateStreakUseCaseProtocol: Sendable {
    func calculateStreak(from days: [ContributionDay]) -> Int
}

public final class CalculateStreakUseCase: CalculateStreakUseCaseProtocol {
    public init() {}

    public func calculateStreak(from days: [ContributionDay]) -> Int {
        var streak = 0
        let calendar = Calendar.current
        let today = Date()

        let sortedDays = days.sorted(by: { $0.date > $1.date })

        var checkDate = today
        for day in sortedDays {
            if calendar.isDate(day.date, inSameDayAs: checkDate) {
                if day.count > 0 {
                    streak += 1
                    guard let prevDate = calendar.date(byAdding: .day, value: -1, to: checkDate) else { break }
                    checkDate = prevDate
                } else if calendar.isDateInToday(checkDate) {
                    guard let prevDate = calendar.date(byAdding: .day, value: -1, to: checkDate) else { break }
                    checkDate = prevDate
                } else {
                    break
                }
            } else if day.date < checkDate {
                break
            }
        }
        return streak
    }
}
