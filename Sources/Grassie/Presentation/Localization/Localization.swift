import Foundation

struct L10n {
    static func streakText(count: Int, language: AppLanguage) -> String {
        switch language {
        case .en:
            return count == 1 ? "\(count) Day" : "\(count) Days"
        case .ko:
            return "\(count)일"
        case .ja:
            return "\(count)日"
        case .zh:
            return "\(count)天"
        }
    }

    private static let strings: [String: [AppLanguage: String]] = [
        // App General & Header
        "settings": [
            .en: "Settings",
            .ko: "설정",
            .ja: "設定",
            .zh: "设置"
        ],
        "save_changes": [
            .en: "Save Changes",
            .ko: "변경사항 저장",
            .ja: "変更を保存",
            .zh: "保存更改"
        ],
        "saved": [
            .en: "Saved!",
            .ko: "저장됨!",
            .ja: "保存されました!",
            .zh: "已保存！"
        ],
        "github_account": [
            .en: "GitHub Account",
            .ko: "GitHub 계정",
            .ja: "GitHub アカウント",
            .zh: "GitHub 账号"
        ],
        "username": [
            .en: "GitHub Username",
            .ko: "GitHub 아이디",
            .ja: "GitHub ユーザー名",
            .zh: "GitHub 用户名"
        ],
        "username_saved_auto": [
            .en: "Username is saved automatically.",
            .ko: "아이디 입력 시 자동으로 저장됩니다.",
            .ja: "ユーザー名は自動的に保存されます。",
            .zh: "用户名将自动保存。"
        ],
        "language": [
            .en: "Language",
            .ko: "언어 설정",
            .ja: "言語設定",
            .zh: "语言设置"
        ],
        "appearance_mode": [
            .en: "Appearance Mode",
            .ko: "외관 테마 설정",
            .ja: "外観モード設定",
            .zh: "外观主题设置"
        ],
        "system_auto": [
            .en: "System Auto",
            .ko: "시스템 자동",
            .ja: "システム連動",
            .zh: "跟随系统"
        ],
        "liquid_dark": [
            .en: "Liquid Dark",
            .ko: "리퀴드 다크",
            .ja: "リキッドダーク",
            .zh: "液态暗黑"
        ],
        "liquid_light": [
            .en: "Liquid Light",
            .ko: "리퀴드 라이트",
            .ja: "リキッドライト",
            .zh: "液态明亮"
        ],
        "system_startup": [
            .en: "System Startup",
            .ko: "시스템 자동 시작",
            .ja: "システム自動起動",
            .zh: "开机自动启动"
        ],
        "launch_at_login": [
            .en: "Launch automatically at macOS login",
            .ko: "macOS 로그인 시 자동 실행",
            .ja: "macOS ログイン時に自動起動",
            .zh: "macOS 登录时自动启动"
        ],
        "launch_at_login_sub": [
            .en: "Start Grassie in background when Mac boots up",
            .ko: "맥 부팅 시 백그라운드에서 실행합니다.",
            .ja: "Mac 起動時にバックグラウンドで開始します。",
            .zh: "Mac 开机时在后台自动运行。"
        ],
        "data_sync": [
            .en: "Data Sync",
            .ko: "데이터 동기화",
            .ja: "数据同期",
            .zh: "数据同步"
        ],
        "refresh_interval": [
            .en: "Auto Refresh Interval",
            .ko: "자동 갱신 주기",
            .ja: "自動更新間隔",
            .zh: "自动刷新间隔"
        ],
        "current_streak": [
            .en: "Current Streak",
            .ko: "현재 연속 커밋",
            .ja: "現在のストリーク",
            .zh: "当前连续提交"
        ],
        "total_contributions": [
            .en: "Total Contributions",
            .ko: "총 커밋 수",
            .ja: "総コントリビューション",
            .zh: "总贡献数"
        ],
        "days": [
            .en: "days",
            .ko: "일",
            .ja: "日",
            .zh: "天"
        ],
        "contribution_graph": [
            .en: "Contribution Graph",
            .ko: "잔디 그래프",
            .ja: "草グラフ",
            .zh: "贡献绿草图"
        ],
        "last_1_month": [
            .en: "Last 1 Month",
            .ko: "최근 1개월",
            .ja: "直近1ヶ月",
            .zh: "最近1个月"
        ],
        "last_3_months": [
            .en: "Last 3 Months",
            .ko: "최근 3개월",
            .ja: "直近3ヶ月",
            .zh: "最近3个月"
        ],
        "last_6_months": [
            .en: "Last 6 Months",
            .ko: "최근 6개월",
            .ja: "直近6ヶ月",
            .zh: "最近6个月"
        ],
        "last_1_year": [
            .en: "Last 1 Year",
            .ko: "최근 1년",
            .ja: "直近1年",
            .zh: "最近1年"
        ],
        "less": [
            .en: "Less",
            .ko: "적음",
            .ja: "少",
            .zh: "较少"
        ],
        "more": [
            .en: "More",
            .ko: "많음",
            .ja: "多",
            .zh: "较多"
        ],
        "view_full_stats": [
            .en: "View Full Stats",
            .ko: "상세 통계 보기",
            .ja: "詳細統計を見る",
            .zh: "查看详细统计"
        ],
        "detailed_stats_report": [
            .en: "Detailed Stats Report",
            .ko: "상세 통계 리포트",
            .ja: "詳細統計レポート",
            .zh: "详细统计报告"
        ],
        "streak_active": [
            .en: "Streak in Progress",
            .ko: "연속 커밋 유지 중",
            .ja: "連続コミット維持中",
            .zh: "连续提交保持中"
        ],
        "streak_achieved": [
            .en: "Days Streak",
            .ko: "일 연속 달성",
            .ja: "日連続達成",
            .zh: "天连续达成"
        ],
        "max_streak": [
            .en: "Best",
            .ko: "최고",
            .ja: "最高",
            .zh: "最高"
        ],
        "streak_prompt_pending": [
            .en: "Extend your streak with a commit today!",
            .ko: "오늘 커밋으로 스트릭을 연장해보세요!",
            .ja: "今日のコミットでストリークを伸ばそう！",
            .zh: "今天提交一次来延长连续记录吧！"
        ],
        "streak_prompt_done": [
            .en: "You planted your grass today! 🎉",
            .ko: "오늘 잔디 심기를 완료했어요! 🎉",
            .ja: "今日の草を生やしました！🎉",
            .zh: "今天已完成绿化！🎉"
        ],
        "this_week_status": [
            .en: "This Week's Activity",
            .ko: "이번 주 잔디 현황",
            .ja: "今週のコミット状況",
            .zh: "本周提交情况"
        ],
        "consistency_rate": [
            .en: "Contribution Rate",
            .ko: "기여 일수 비율",
            .ja: "貢献日数比率",
            .zh: "贡献天数比例"
        ],
        "top_percent_badge": [
            .en: "Top 5% Consistency",
            .ko: "상위 5% 달성",
            .ja: "上位5%達成",
            .zh: "排名前 5%"
        ],
        "steady_dev_badge": [
            .en: "Consistent Dev",
            .ko: "꾸준한 개발자",
            .ja: "継続的な開発者",
            .zh: "持之以恒的开发者"
        ],
        "this_year_contributions": [
            .en: "This year",
            .ko: "올해",
            .ja: "今年",
            .zh: "今年"
        ],
        "sync_completed": [
            .en: "Sync Completed",
            .ko: "동기화 완료",
            .ja: "同期完了",
            .zh: "同步完成"
        ],
        "live_synced": [
            .en: "Live synced",
            .ko: "실시간 동기화",
            .ja: "ライブ同期",
            .zh: "实时同步"
        ],
        "quit_app": [
            .en: "Quit App",
            .ko: "앱 종료",
            .ja: "アプリ終了",
            .zh: "退出应用"
        ],
        "fetching_contributions": [
            .en: "Fetching GitHub contributions...",
            .ko: "GitHub 잔디를 불러오는 중...",
            .ja: "GitHubのデータを取得中...",
            .zh: "正在获取 GitHub 贡献数据..."
        ]
    ]

    static func string(_ key: String, language: AppLanguage) -> String {
        return strings[key]?[language] ?? strings[key]?[.en] ?? key
    }
}
