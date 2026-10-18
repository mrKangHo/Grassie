import Foundation

public protocol CalculateStreakUseCaseProtocol: Sendable {
    func calculateStreak(from days: [ContributionDay]) -> Int
    func calculateLongestStreak(from days: [ContributionDay]) -> Int
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

    public func calculateLongestStreak(from days: [ContributionDay]) -> Int {
        let calendar = Calendar.current
        let sortedDays = days.sorted(by: { $0.date < $1.date })

        var maxStreak = 0
        var currentRunningStreak = 0
        var previousDate: Date? = nil

        for day in sortedDays {
            guard day.count > 0 else {
                currentRunningStreak = 0
                previousDate = nil
                continue
            }

            if let prev = previousDate {
                let dayDifference = calendar.dateComponents([.day], from: calendar.startOfDay(for: prev), to: calendar.startOfDay(for: day.date)).day ?? 0
                if dayDifference == 1 {
                    currentRunningStreak += 1
                } else if dayDifference > 1 {
                    currentRunningStreak = 1
                }
            } else {
                currentRunningStreak = 1
            }

            previousDate = day.date
            if currentRunningStreak > maxStreak {
                maxStreak = currentRunningStreak
            }
        }

        return maxStreak
    }
}

