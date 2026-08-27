import Foundation
import Combine
import SwiftUI
import ServiceManagement

enum AppTheme: String, CaseIterable, Identifiable {
    case auto = "System Auto"
    case liquidDark = "Liquid Dark"
    case liquidLight = "Liquid Light"

    var id: String { self.rawValue }

    var labelKey: String {
        switch self {
        case .auto: return "system_auto"
        case .liquidDark: return "liquid_dark"
        case .liquidLight: return "liquid_light"
        }
    }

    func isDark(colorScheme: ColorScheme) -> Bool {
        switch self {
        case .auto:
            return colorScheme == .dark
        case .liquidDark:
            return true
        case .liquidLight:
            return false
        }
    }

    func backgroundColor(isDark: Bool) -> Color {
        return isDark ? Color(hex: "0E1014").opacity(0.92) : Color(hex: "F2F4F8")
    }

    func headerBackgroundColor(isDark: Bool) -> Color {
        return isDark ? Color.black.opacity(0.45) : Color.white.opacity(0.85)
    }

    func cardBackgroundColor(isDark: Bool) -> Color {
        return isDark ? Color.black.opacity(0.35) : Color.white
    }

    func textColor(isDark: Bool) -> Color {
        return isDark ? .white : Color(hex: "111318")
    }

    func secondaryTextColor(isDark: Bool) -> Color {
        return isDark ? Color.white.opacity(0.85) : Color(hex: "111318").opacity(0.75)
    }

    func strokeColor(isDark: Bool) -> Color {
        return isDark ? Color.white.opacity(0.22) : Color.black.opacity(0.12)
    }

    // High-Contrast Theme-Aware Grass Color Palette Engine (UI/UX Pro Max)
    func grassColor(for level: Int, isDark: Bool) -> Color {
        if isDark {
            switch level {
            case 1: return Color(hex: "0E4429")
            case 2: return Color(hex: "006E1A")
            case 3: return Color(hex: "28C840")
            case 4: return Color(hex: "71FF74")
            default: return Color.white.opacity(0.12)
            }
        } else {
            switch level {
            case 1: return Color(hex: "9BE9A8")
            case 2: return Color(hex: "40C463")
            case 3: return Color(hex: "30A14E")
            case 4: return Color(hex: "216E39")
            default: return Color(hex: "EBEDF0")
            }
        }
    }

    func grassBorderColor(for level: Int, isDark: Bool) -> Color {
        if isDark {
            return level == 0 ? Color.white.opacity(0.18) : Color.white.opacity(0.3)
        } else {
            return level == 0 ? Color.black.opacity(0.08) : Color.black.opacity(0.2)
        }
    }
}

class AutoLaunchManager {
    static let shared = AutoLaunchManager()
    private init() {}

    var isEnabled: Bool {
        if #available(macOS 13.0, *) {
            let status = SMAppService.mainApp.status
            if status == .enabled {
                return true
            }
        }
        return UserDefaults.standard.bool(forKey: "auto_launch_enabled")
    }

    func setEnabled(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: "auto_launch_enabled")
        if #available(macOS 13.0, *) {
            do {
                if enabled {
                    if SMAppService.mainApp.status != .enabled {
                        try SMAppService.mainApp.register()
                    }
                } else {
                    if SMAppService.mainApp.status == .enabled {
                        try SMAppService.mainApp.unregister()
                    }
                }
            } catch {
                print("Failed to toggle auto launch: \(error.localizedDescription)")
            }
        }
    }
}

enum TimeframeRange: String, CaseIterable, Identifiable {
    case oneMonth = "1M"
    case threeMonths = "3M"
    case sixMonths = "6M"
    case oneYear = "1Y"

    var id: String { self.rawValue }

    func label(language: AppLanguage) -> String {
        switch self {
        case .oneMonth: return L10n.string("last_1_month", language: language)
        case .threeMonths: return L10n.string("last_3_months", language: language)
        case .sixMonths: return L10n.string("last_6_months", language: language)
        case .oneYear: return L10n.string("last_1_year", language: language)
        }
    }
}

struct ContributionDay: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
    let level: Int
}

class ContributionViewModel: ObservableObject {
    private static let usernameKey = "github_username"
    private static let themeKey = "app_theme"
    private static let languageKey = "app_language"

    @Published var username: String {
        didSet {
            let trimmed = username.trimmingCharacters(in: .whitespacesAndNewlines)
            UserDefaults.standard.set(trimmed, forKey: Self.usernameKey)
            if !trimmed.isEmpty {
                loadLiveData()
            } else {
                days = []
                currentStreak = 0
                totalContributions = 0
            }
        }
    }

    @Published var selectedTheme: AppTheme {
        didSet {
            UserDefaults.standard.set(selectedTheme.rawValue, forKey: Self.themeKey)
        }
    }

    @Published var selectedLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set(selectedLanguage.rawValue, forKey: Self.languageKey)
        }
    }

    @Published var autoLaunchAtLogin: Bool {
        didSet {
            AutoLaunchManager.shared.setEnabled(autoLaunchAtLogin)
        }
    }

    @Published var currentStreak: Int = 0
    @Published var totalContributions: Int = 0
    @Published var bestDayCount: Int = 0
    @Published var bestDayDate: String = ""
    @Published var activeConsistency: Double = 0.0

    @Published var days: [ContributionDay] = []
    @Published var selectedRange: TimeframeRange = .oneYear
    @Published var isRefreshing: Bool = false
    @Published var isLoading: Bool = false
    @Published var lastUpdated: String = "Just now"
    @Published var errorMessage: String? = nil

    // Dynamic Streak Emoji Engine (0d: 🌱, 1~6d: 🌿, 7~29d: 🔥, 30~99d: 🚀, 100d+: 👑)
    var streakBadgeEmoji: String {
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

    init() {
        let savedUsername = UserDefaults.standard.string(forKey: Self.usernameKey) ?? ""
        let cleanUsername = savedUsername.trimmingCharacters(in: .whitespacesAndNewlines)

        if cleanUsername == "lee" {
            UserDefaults.standard.removeObject(forKey: Self.usernameKey)
            self.username = ""
        } else {
            self.username = cleanUsername
        }

        let savedThemeStr = UserDefaults.standard.string(forKey: Self.themeKey) ?? "System Auto"
        self.selectedTheme = AppTheme(rawValue: savedThemeStr) ?? .auto

        if let savedLangStr = UserDefaults.standard.string(forKey: Self.languageKey),
           let lang = AppLanguage(rawValue: savedLangStr) {
            self.selectedLanguage = lang
        } else {
            self.selectedLanguage = AppLanguage.systemDefault
        }

        self.autoLaunchAtLogin = AutoLaunchManager.shared.isEnabled

        if !self.username.isEmpty {
            loadLiveData()
        }
    }

    func tr(_ key: String) -> String {
        return L10n.string(key, language: selectedLanguage)
    }

    func filteredDays(for range: TimeframeRange) -> [ContributionDay] {
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

    func loadLiveData() {
        let cleanUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanUsername.isEmpty else {
            isLoading = false
            isRefreshing = false
            return
        }

        isLoading = true
        isRefreshing = true
        errorMessage = nil

        GitHubAPIService.shared.fetchContributions(username: cleanUsername) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                self.isRefreshing = false

                switch result {
                case .success(let data):
                    self.days = data.days
                    self.totalContributions = data.totalContributions
                    self.currentStreak = data.currentStreak
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

    func refresh() {
        loadLiveData()
    }
}
