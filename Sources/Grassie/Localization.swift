import Foundation

enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case korean = "ko"
    case japanese = "ja"
    case chinese = "zh"

    var id: String { self.rawValue }

    var displayName: String {
        switch self {
        case .english: return "English"
        case .korean: return "한국어"
        case .japanese: return "日本語"
        case .chinese: return "中文"
        }
    }

    static var systemDefault: AppLanguage {
        let preferred = (Locale.preferredLanguages.first ?? "en").lowercased()

        if preferred.hasPrefix("ko") {
            return .korean
        } else if preferred.hasPrefix("ja") {
            return .japanese
        } else if preferred.hasPrefix("zh") {
            return .chinese
        } else {
            return .english
        }
    }
}

struct L10n {
    private static let translations: [String: [AppLanguage: String]] = [
        "current_streak": [
            .english: "Current Streak",
            .korean: "현재 연속 달성",
            .japanese: "現在の連続達成",
            .chinese: "当前连续"
        ],
        "total_contributions": [
            .english: "Total Contributions",
            .korean: "총 커밋 / 잔디",
            .japanese: "総貢献数",
            .chinese: "总贡献数"
        ],
        "days": [
            .english: "days",
            .korean: "일",
            .japanese: "日",
            .chinese: "天"
        ],
        "contribution_graph": [
            .english: "Contribution Graph",
            .korean: "잔디 그래프",
            .japanese: "貢献グラフ",
            .chinese: "贡献图表"
        ],
        "last_1_month": [
            .english: "Last 1 Month",
            .korean: "최근 1개월",
            .japanese: "過去1ヶ月",
            .chinese: "最近1个月"
        ],
        "last_3_months": [
            .english: "Last 3 Months",
            .korean: "최근 3개월",
            .japanese: "過去3ヶ月",
            .chinese: "最近3个月"
        ],
        "last_6_months": [
            .english: "Last 6 Months",
            .korean: "최근 6개월",
            .japanese: "過去6ヶ月",
            .chinese: "最近6个月"
        ],
        "last_1_year": [
            .english: "Last 1 Year",
            .korean: "최근 1년",
            .japanese: "過去1年",
            .chinese: "最近1年"
        ],
        "view_full_stats": [
            .english: "View Full Stats",
            .korean: "전체 통계 보기",
            .japanese: "詳細統計を見る",
            .chinese: "查看完整统计"
        ],
        "settings": [
            .english: "Settings",
            .korean: "설정",
            .japanese: "設定",
            .chinese: "设置"
        ],
        "github_account": [
            .english: "GitHub Account",
            .korean: "GitHub 계정",
            .japanese: "GitHub アカウント",
            .chinese: "GitHub 账号"
        ],
        "username": [
            .english: "Username",
            .korean: "사용자명",
            .japanese: "ユーザー名",
            .chinese: "用户名"
        ],
        "username_saved_auto": [
            .english: "Username (Saved automatically)",
            .korean: "사용자명 (자동 저장됨)",
            .japanese: "ユーザー名（自動保存）",
            .chinese: "用户名（自动保存）"
        ],
        "system_startup": [
            .english: "System Startup",
            .korean: "시스템 시작 설정",
            .japanese: "システム起動設定",
            .chinese: "系统启动设置"
        ],
        "launch_at_login": [
            .english: "Launch automatically at macOS login",
            .korean: "macOS 로그인 시 자동 실행",
            .japanese: "macOS ログイン時に自動起動",
            .chinese: "macOS 登录时自动启动"
        ],
        "launch_at_login_sub": [
            .english: "App starts silently in Menu Bar upon system boot",
            .korean: "부팅 시 메뉴바에 자동 등록되어 배경 실행됩니다",
            .japanese: "起動時にメニューバーでバックグラウンド実行されます",
            .chinese: "系统启动时在菜单栏后台自动运行"
        ],
        "appearance_mode": [
            .english: "Appearance Mode",
            .korean: "외관 테마 모드",
            .japanese: "外観モード",
            .chinese: "外观模式"
        ],
        "system_auto": [
            .english: "System Auto",
            .korean: "시스템 자동",
            .japanese: "시스템自動",
            .chinese: "系统自动"
        ],
        "liquid_dark": [
            .english: "Liquid Dark",
            .korean: "리퀴드 다크",
            .japanese: "Liquid Dark",
            .chinese: "Liquid Dark"
        ],
        "liquid_light": [
            .english: "Liquid Light",
            .korean: "리퀴드 라이트",
            .japanese: "Liquid Light",
            .chinese: "Liquid Light"
        ],
        "language": [
            .english: "Language",
            .korean: "언어 설정",
            .japanese: "言語設定",
            .chinese: "语言设置"
        ],
        "data_sync": [
            .english: "Data Sync",
            .korean: "데이터 동기화",
            .japanese: "データ同期",
            .chinese: "数据同步"
        ],
        "refresh_interval": [
            .english: "Refresh Interval",
            .korean: "갱신 주기",
            .japanese: "更新間隔",
            .chinese: "刷新间隔"
        ],
        "save_changes": [
            .english: "Save Changes",
            .korean: "변경사항 저장",
            .japanese: "変更を保存",
            .chinese: "保存更改"
        ],
        "saved": [
            .english: "Saved",
            .korean: "저장됨",
            .japanese: "保存済み",
            .chinese: "已保存"
        ],
        "less": [
            .english: "Less",
            .korean: "적음",
            .japanese: "少ない",
            .chinese: "少"
        ],
        "more": [
            .english: "More",
            .korean: "많음",
            .japanese: "多い",
            .chinese: "多"
        ],
        "fetching_contributions": [
            .english: "Fetching live GitHub contributions...",
            .korean: "실시간 GitHub 커밋 데이터를 불러오는 중...",
            .japanese: "Live GitHub データを取得中...",
            .chinese: "正在获取 GitHub 实时贡献..."
        ]
    ]

    static func string(_ key: String, language: AppLanguage) -> String {
        if let dict = translations[key], let val = dict[language] {
            return val
        }
        return translations[key]?[.english] ?? key
    }
}
