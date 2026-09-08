import Foundation
import Combine
import SwiftUI

public final class ContributionViewModel: ObservableObject {
    private let fetchContributionsUseCase: FetchContributionsUseCaseProtocol
    private let calculateStreakUseCase: CalculateStreakUseCaseProtocol
    private let settingsRepository: SettingsRepositoryProtocol

    @Published public var username: String {
        didSet {
            let trimmed = username.trimmingCharacters(in: .whitespacesAndNewlines)
            settingsRepository.username = trimmed
            if !trimmed.isEmpty {
                loadLiveData()
            } else {
                days = []
                currentStreak = 0
                totalContributions = 0
            }
        }
    }

    @Published public var selectedTheme: AppTheme {
        didSet {
            settingsRepository.theme = selectedTheme
        }
    }

    @Published public var selectedLanguage: AppLanguage {
        didSet {
            settingsRepository.language = selectedLanguage
        }
    }

    @Published public var autoLaunchAtLogin: Bool {
        didSet {
            settingsRepository.autoLaunchEnabled = autoLaunchAtLogin
        }
    }

    @Published public var refreshIntervalMinutes: Int {
        didSet {
            settingsRepository.refreshIntervalMinutes = refreshIntervalMinutes
            scheduleAutoRefresh()
        }
    }

    private var refreshTimer: Timer?

    @Published public var currentStreak: Int = 0
    @Published public var totalContributions: Int = 0
    @Published public var bestDayCount: Int = 0
    @Published public var bestDayDate: String = ""
    @Published public var activeConsistency: Double = 0.0

    @Published public var days: [ContributionDay] = []
    @Published public var selectedRange: TimeframeRange = .oneYear
    @Published public var isRefreshing: Bool = false
    @Published public var isLoading: Bool = false
    @Published public var lastUpdated: String = "Just now"
    @Published public var errorMessage: String? = nil

    public var streakBadgeEmoji: String {
        switch currentStreak {
        case 0:
            return "🌱"
        case 1..<7:
            return "🌿"
        case 7..<30:
            return "🔥"
        case 30..<100:
            return "🚀"
        default:
            return "👑"
        }
    }

    public init(
        fetchContributionsUseCase: FetchContributionsUseCaseProtocol = AppDIContainer.shared.fetchContributionsUseCase,
        calculateStreakUseCase: CalculateStreakUseCaseProtocol = AppDIContainer.shared.calculateStreakUseCase,
        settingsRepository: SettingsRepositoryProtocol = AppDIContainer.shared.settingsRepository
    ) {
        self.fetchContributionsUseCase = fetchContributionsUseCase
        self.calculateStreakUseCase = calculateStreakUseCase
        self.settingsRepository = settingsRepository

        self.username = settingsRepository.username
        self.selectedTheme = settingsRepository.theme
        self.selectedLanguage = settingsRepository.language
        self.autoLaunchAtLogin = settingsRepository.autoLaunchEnabled
        self.refreshIntervalMinutes = settingsRepository.refreshIntervalMinutes

        if !self.username.isEmpty {
            loadLiveData()
        }

        scheduleAutoRefresh()
    }

    deinit {
        refreshTimer?.invalidate()
    }

    private func scheduleAutoRefresh() {
        refreshTimer?.invalidate()
        let interval = TimeInterval(refreshIntervalMinutes * 60)
        refreshTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            guard let self = self, !self.username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
            self.loadLiveData()
        }
    }

    public func tr(_ key: String) -> String {
        return L10n.string(key, language: selectedLanguage)
    }

    public func filteredDays(for range: TimeframeRange) -> [ContributionDay] {
        let calendar = Calendar.current
        let today = Date()

        switch range {
        case .oneMonth:
            guard let startDate = calendar.date(byAdding: .month, value: -1, to: today) else { return days }
            return days.filter { $0.date >= startDate }
        case .threeMonths:
            guard let startDate = calendar.date(byAdding: .month, value: -3, to: today) else { return days }
            return days.filter { $0.date >= startDate }
        case .sixMonths:
            guard let startDate = calendar.date(byAdding: .month, value: -6, to: today) else { return days }
            return days.filter { $0.date >= startDate }
        case .oneYear:
            return days
        }
    }

    public func loadLiveData() {
        let cleanUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanUsername.isEmpty else {
            isLoading = false
            isRefreshing = false
            return
        }

        isLoading = true
        isRefreshing = true
        errorMessage = nil

        fetchContributionsUseCase.execute(username: cleanUsername) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                self.isRefreshing = false

                switch result {
                case .success(let data):
                    self.days = data.days
                    self.totalContributions = data.totalContributions
                    self.currentStreak = self.calculateStreakUseCase.calculateStreak(from: data.days)
                    self.bestDayCount = data.bestDayCount
                    self.bestDayDate = data.bestDayDate
                    self.activeConsistency = data.activeConsistency

                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH:mm"
                    self.lastUpdated = "Updated \(formatter.string(from: Date()))"

                case .failure(let error):
                    self.errorMessage = "Failed to load: \(error.localizedDescription)"
                    self.lastUpdated = "Sync error"
                }
            }
        }
    }

    public func refresh() {
        loadLiveData()
    }
}
