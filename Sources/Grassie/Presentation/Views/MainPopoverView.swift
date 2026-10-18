import SwiftUI

enum ActivePopoverScreen {
    case main
    case settings
    case stats
}

struct MainPopoverView: View {
    @ObservedObject var viewModel: ContributionViewModel
    var onOpenStats: (() -> Void)? = nil
    var onOpenSettings: (() -> Void)? = nil

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var activeScreen: ActivePopoverScreen = .main
    @State private var hoveredDay: ContributionDay? = nil

    private var isDark: Bool {
        viewModel.selectedTheme.isDark(colorScheme: colorScheme)
    }

    private var theme: AppTheme {
        viewModel.selectedTheme
    }

    private var cellSize: CGFloat {
        switch viewModel.selectedRange {
        case .oneMonth:
            return 28.0
        case .threeMonths:
            return 19.0
        case .sixMonths:
            return 13.5
        case .oneYear:
            return 10.0
        }
    }

    private var cellSpacing: CGFloat {
        switch viewModel.selectedRange {
        case .oneMonth:
            return 5.0
        case .threeMonths:
            return 4.0
        case .sixMonths:
            return 3.5
        case .oneYear:
            return 3.0
        }
    }

    private var cornerRadius: CGFloat {
        switch viewModel.selectedRange {
        case .oneMonth:
            return 5.0
        case .threeMonths:
            return 4.0
        default:
            return 2.5
        }
    }

    private var targetPopoverHeight: CGFloat {
        switch activeScreen {
        case .main:
            return 640.0
        case .settings:
            return 460.0
        case .stats:
            return 500.0
        }
    }

    private var gridHeight: CGFloat {
        return (cellSize * 7) + (cellSpacing * 6) + 4
    }

    var body: some View {
        ZStack {
            // macOS Translucent Base
            VisualEffectView(
                material: isDark ? .hudWindow : .headerView,
                blendingMode: .behindWindow
            )

            // Stitch Ambient Glow Blobs
            StitchAmbientGlowView(isDark: isDark)

            switch activeScreen {
            case .main:
                mainContentView
                    .transition(.applePush(edge: .leading, reduceMotion: reduceMotion))
            case .settings:
                SettingsView(
                    viewModel: viewModel,
                    onBack: {
                        withAnimation(.appleSpring(reduceMotion: reduceMotion)) {
                            activeScreen = .main
                            updatePopoverHeight(640.0)
                        }
                    }
                )
                .transition(.applePush(edge: .trailing, reduceMotion: reduceMotion))
            case .stats:
                StatisticsView(
                    viewModel: viewModel,
                    onBack: {
                        withAnimation(.appleSpring(reduceMotion: reduceMotion)) {
                            activeScreen = .main
                            updatePopoverHeight(640.0)
                        }
                    },
                    onOpenSettings: {
                        withAnimation(.appleSpring(reduceMotion: reduceMotion)) {
                            activeScreen = .settings
                            updatePopoverHeight(460.0)
                        }
                    },
                    onOpenOnboarding: {}
                )
                .transition(.applePush(edge: .trailing, reduceMotion: reduceMotion))
            }
        }
        .frame(width: 390, height: targetPopoverHeight)
        .onAppear {
            updatePopoverHeight(targetPopoverHeight)
        }
    }

    // MARK: - Main Content View
    private var mainContentView: some View {
        VStack(spacing: 0) {
            // Top Bar & Header
            headerView

            // Scrollable Main Content Area
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 12) {
                    if viewModel.isLoading && viewModel.days.isEmpty {
                        loadingPlaceholderView
                    } else {
                        // 1. Hero Streak Widget Card
                        heroStreakCard

                        // 2. Metrics Split Cards (2 Columns)
                        metricsSplitSection

                        // 3. Grass Heatmap Section
                        grassHeatmapSection

                        // 4. Floating Action CTA Row
                        actionCtaRow
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 14)
                .padding(.bottom, 16)
            }
        }
    }

    // MARK: - Header
    private var headerView: some View {
        HStack(spacing: 10) {
            // App Modern Gradient Logo
            ZStack(alignment: .bottomTrailing) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [Color.stitchIndigo, Color.stitchBlue, Color.stitchEmerald],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 38, height: 38)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.5)
                            .fill(isDark ? Color(hex: "151D2A") : Color.white)
                            .padding(1.5)
                            .overlay(
                                Text("G")
                                    .font(.system(size: 15, weight: .black, design: .monospaced))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [Color.stitchIndigo, Color.stitchEmerald],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                    )

                // Online Live Indicator
                Circle()
                    .fill(Color.stitchEmerald)
                    .frame(width: 9, height: 9)
                    .overlay(Circle().stroke(isDark ? Color(hex: "151D2A") : Color.white, lineWidth: 1.5))
                    .offset(x: 2, y: 2)
            }

            // Title & Username & Live Sync
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text("Grassie")
                        .font(.system(size: 15, weight: .bold, design: .default))
                        .foregroundColor(isDark ? .white : Color.stitchSlate900)

                    // GitHub Username Badge
                    Button(action: {
                        if let url = URL(string: "https://github.com/\(viewModel.username)") {
                            NSWorkspace.shared.open(url)
                        }
                    }) {
                        HStack(spacing: 3.5) {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 9))
                            Text("@\(viewModel.username)")
                                .font(.system(size: 10.5, weight: .bold, design: .monospaced))
                        }
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2.5)
                        .background(isDark ? Color.white.opacity(0.12) : Color.stitchSlate100)
                        .foregroundColor(isDark ? Color.stitchSlate200 : Color.stitchSlate700)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isDark ? Color.white.opacity(0.1) : Color.stitchSlate200, lineWidth: 0.5)
                        )
                    }
                    .buttonStyle(.applePress(scale: 0.95))
                }

                // Live Synced Indicator
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.stitchEmerald)
                        .frame(width: 5, height: 5)
                    Text("\(viewModel.tr("live_synced")) · \(viewModel.lastUpdated)")
                        .font(.system(size: 10, weight: .medium, design: .monospaced))
                        .foregroundColor(isDark ? Color.stitchSlate400 : Color.stitchSlate500)
                }
            }

            Spacer()

            // Header Action Buttons
            HStack(spacing: 6) {
                // Quick Refresh Button
                Button(action: {
                    viewModel.refresh()
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(isDark ? Color.stitchSlate200 : Color.stitchSlate700)
                        .frame(width: 30, height: 30)
                        .background(isDark ? Color(hex: "1F2937") : Color.white)
                        .cornerRadius(9)
                        .overlay(
                            RoundedRectangle(cornerRadius: 9)
                                .stroke(isDark ? Color.white.opacity(0.12) : Color.stitchSlate200, lineWidth: 1)
                        )
                        .rotationEffect(.degrees(viewModel.isRefreshing ? 360 : 0))
                        .animation(
                            viewModel.isRefreshing
                                ? .linear(duration: 0.8).repeatForever(autoreverses: false)
                                : .default,
                            value: viewModel.isRefreshing
                        )
                }
                .buttonStyle(.applePress(scale: 0.92))
                .help(viewModel.tr("refresh"))

                // Settings Button
                Button(action: {
                    withAnimation(.appleSpring(reduceMotion: reduceMotion)) {
                        activeScreen = .settings
                        updatePopoverHeight(460.0)
                    }
                }) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(isDark ? Color.stitchSlate200 : Color.stitchSlate700)
                        .frame(width: 30, height: 30)
                        .background(isDark ? Color(hex: "1F2937") : Color.white)
                        .cornerRadius(9)
                        .overlay(
                            RoundedRectangle(cornerRadius: 9)
                                .stroke(isDark ? Color.white.opacity(0.12) : Color.stitchSlate200, lineWidth: 1)
                        )
                }
                .buttonStyle(.applePress(scale: 0.92))
                .help(viewModel.tr("settings"))

                // Quit App Button
                Button(action: {
                    NSApplication.shared.terminate(nil)
                }) {
                    Image(systemName: "power")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color.red.opacity(0.85))
                        .frame(width: 30, height: 30)
                        .background(Color.red.opacity(isDark ? 0.15 : 0.08))
                        .cornerRadius(9)
                        .overlay(
                            RoundedRectangle(cornerRadius: 9)
                                .stroke(Color.red.opacity(0.25), lineWidth: 1)
                        )
                }
                .buttonStyle(.applePress(scale: 0.92))
                .help(viewModel.tr("quit_app"))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            (isDark ? Color(hex: "131A26").opacity(0.85) : Color.white.opacity(0.92))
                .backdropBlur()
        )
        .overlay(
            Divider().background(isDark ? Color.white.opacity(0.1) : Color.stitchSlate200.opacity(0.8)),
            alignment: .bottom
        )
    }

    // MARK: - 1. Hero Streak Widget Card
    private var heroStreakCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    // Badge
                    HStack(spacing: 4) {
                        Text("🔥")
                            .font(.system(size: 10))
                        Text(viewModel.tr("streak_active"))
                            .font(.system(size: 10.5, weight: .bold))
                            .foregroundColor(isDark ? Color(hex: "FDE68A") : Color.stitchAmber700)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(isDark ? Color(hex: "78350F").opacity(0.35) : Color.stitchAmber50)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isDark ? Color(hex: "B45309").opacity(0.4) : Color.stitchAmber200.opacity(0.6), lineWidth: 0.8)
                    )

                    // Large Streak Count
                    HStack(alignment: .firstTextBaseline, spacing: 5) {
                        Text("\(viewModel.currentStreak)")
                            .font(.system(size: 30, weight: .heavy, design: .rounded))
                            .foregroundColor(isDark ? .white : Color.stitchSlate900)

                        Text(viewModel.tr("streak_achieved"))
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(isDark ? Color.stitchSlate400 : Color.stitchSlate500)

                        if viewModel.longestStreak > 0 {
                            Text("· \(viewModel.tr("max_streak")) \(viewModel.longestStreak)\(viewModel.tr("days"))")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(isDark ? Color.stitchSlate500 : Color.stitchSlate400)
                        }
                    }

                    // Prompt Message
                    Text(viewModel.todayCount > 0 ? viewModel.tr("streak_prompt_done") : viewModel.tr("streak_prompt_pending"))
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(isDark ? Color.stitchSlate400 : Color.stitchSlate500)
                }

                Spacer()

                // Flame Badge Icon Box
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(
                            LinearGradient(
                                colors: [Color.stitchAmber500, Color.stitchOrange500],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 44, height: 44)
                        .shadow(color: Color.stitchOrange500.opacity(0.35), radius: 6, x: 0, y: 3)

                    Image(systemName: "flame.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
            }

            Divider()
                .background(isDark ? Color.white.opacity(0.08) : Color.stitchSlate100)

            // Weekly Progress Dot Matrix (Mon - Sun)
            VStack(alignment: .leading, spacing: 6) {
                Text(viewModel.tr("this_week_status"))
                    .font(.system(size: 10.5, weight: .semibold))
                    .foregroundColor(isDark ? Color.stitchSlate400 : Color.stitchSlate400)

                HStack(spacing: 8) {
                    ForEach(viewModel.thisWeekStatuses) { status in
                        VStack(spacing: 3) {
                            Text(status.symbol)
                                .font(.system(size: 9, weight: status.isToday ? .heavy : .semibold, design: .monospaced))
                                .foregroundColor(
                                    status.isToday
                                        ? Color.stitchIndigo
                                        : (isDark ? Color.stitchSlate400 : Color.stitchSlate400)
                                )

                            // Day Block
                            ZStack {
                                if status.count > 0 {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.stitchEmerald500)
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 9, weight: .heavy))
                                        .foregroundColor(.white)
                                } else if status.isToday {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(isDark ? Color(hex: "1F2937") : Color.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 6)
                                                .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [3, 2]))
                                                .foregroundColor(Color.stitchAmber500)
                                        )
                                    Text("!")
                                        .font(.system(size: 10, weight: .black, design: .rounded))
                                        .foregroundColor(Color.stitchAmber500)
                                } else {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(isDark ? Color.white.opacity(0.06) : Color.stitchSlate100)
                                }
                            }
                            .frame(width: 22, height: 22)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .padding(14)
        .stitchCard(isDark: isDark, cornerRadius: 16)
    }

    // MARK: - 2. Metrics Split Cards (2 Columns)
    private var metricsSplitSection: some View {
        HStack(spacing: 10) {
            // Card 1: Total Commits
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(viewModel.tr("total_contributions"))
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(isDark ? Color.stitchSlate400 : Color.stitchSlate500)
                    Spacer()
                    Image(systemName: "arrow.triangle.branch")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color.stitchBlue)
                        .frame(width: 22, height: 22)
                        .background(Color.stitchBlue.opacity(0.12))
                        .cornerRadius(6)
                }

                Text("\(viewModel.totalContributions.formatted())")
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .foregroundColor(isDark ? .white : Color.stitchSlate900)

                HStack(spacing: 3) {
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 9, weight: .bold))
                    Text("\(viewModel.tr("this_year_contributions")) +\(viewModel.thisYearContributions)")
                        .font(.system(size: 10, weight: .semibold))
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 2.5)
                .background(Color.stitchEmerald.opacity(0.12))
                .foregroundColor(Color.stitchEmerald600)
                .cornerRadius(6)
            }
            .padding(12)
            .stitchCard(isDark: isDark, cornerRadius: 14)

            // Card 2: Contribution Consistency
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(viewModel.tr("consistency_rate"))
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(isDark ? Color.stitchSlate400 : Color.stitchSlate500)
                    Spacer()
                    Image(systemName: "chart.pie.fill")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color.stitchIndigo)
                        .frame(width: 22, height: 22)
                        .background(Color.stitchIndigo.opacity(0.12))
                        .cornerRadius(6)
                }

                HStack(alignment: .firstTextBaseline, spacing: 1) {
                    Text(String(format: "%.1f", viewModel.activeConsistency))
                        .font(.system(size: 22, weight: .heavy, design: .rounded))
                        .foregroundColor(isDark ? .white : Color.stitchSlate900)
                    Text("%")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(isDark ? Color.stitchSlate400 : Color.stitchSlate500)
                }

                HStack(spacing: 3) {
                    Image(systemName: "award.fill")
                        .font(.system(size: 9, weight: .bold))
                    Text(viewModel.tr("top_percent_badge"))
                        .font(.system(size: 10, weight: .semibold))
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 2.5)
                .background(Color.stitchIndigo.opacity(0.12))
                .foregroundColor(Color.stitchIndigo)
                .cornerRadius(6)
            }
            .padding(12)
            .stitchCard(isDark: isDark, cornerRadius: 14)
        }
    }

    // MARK: - 3. Grass Heatmap Section
    private var grassHeatmapSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Header & Range Switcher
            HStack {
                HStack(spacing: 6) {
                    Circle()
                        .fill(Color.stitchEmerald)
                        .frame(width: 7, height: 7)
                        .shadow(color: Color.stitchEmerald.opacity(0.6), radius: 3)

                    Text(viewModel.tr("contribution_graph"))
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(isDark ? .white : Color.stitchSlate900)
                }

                Spacer()

                // Pill Range Switcher
                HStack(spacing: 2) {
                    ForEach(TimeframeRange.allCases) { range in
                        Button(action: {
                            withAnimation(.appleSpring(response: 0.25, dampingFraction: 0.75, reduceMotion: reduceMotion)) {
                                viewModel.selectedRange = range
                            }
                        }) {
                            Text(range.rawValue)
                                .font(.system(size: 10.5, weight: .bold, design: .monospaced))
                                .foregroundColor(
                                    viewModel.selectedRange == range
                                        ? Color.stitchIndigo
                                        : (isDark ? Color.stitchSlate400 : Color.stitchSlate500)
                                )
                                .padding(.horizontal, 7)
                                .padding(.vertical, 3.5)
                                .background(
                                    viewModel.selectedRange == range
                                        ? (isDark ? Color(hex: "1F2937") : Color.white)
                                        : Color.clear
                                )
                                .cornerRadius(7)
                                .shadow(
                                    color: viewModel.selectedRange == range
                                        ? Color.black.opacity(isDark ? 0.25 : 0.05)
                                        : Color.clear,
                                    radius: 2,
                                    x: 0,
                                    y: 1
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(2)
                .background(isDark ? Color.white.opacity(0.06) : Color.stitchSlate100)
                .cornerRadius(9)
            }

            // Heatmap Grid
            let activeDays = viewModel.filteredDays(for: viewModel.selectedRange)

            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(isDark ? Color.white.opacity(0.03) : Color.stitchSlate50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isDark ? Color.white.opacity(0.06) : Color.stitchSlate200.opacity(0.7), lineWidth: 0.8)
                    )

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(
                        rows: Array(repeating: GridItem(.fixed(cellSize), spacing: cellSpacing), count: 7),
                        spacing: cellSpacing
                    ) {
                        ForEach(activeDays) { day in
                            Rectangle()
                                .fill(theme.grassColor(for: day.level, isDark: isDark))
                                .frame(width: cellSize, height: cellSize)
                                .cornerRadius(cornerRadius)
                                .overlay(
                                    RoundedRectangle(cornerRadius: cornerRadius)
                                        .stroke(theme.grassBorderColor(for: day.level, isDark: isDark), lineWidth: 0.5)
                                )
                                .scaleEffect(reduceMotion ? 1.0 : (hoveredDay?.id == day.id ? 1.25 : 1.0))
                                .animation(
                                    .appleSpring(response: 0.2, dampingFraction: 0.85, reduceMotion: reduceMotion),
                                    value: hoveredDay?.id == day.id
                                )
                                .onHover { isHovered in
                                    if isHovered {
                                        hoveredDay = day
                                    }
                                }
                        }
                    }
                    .padding(8)
                }
            }
            .frame(height: gridHeight + 16)

            // Footer Tooltip & Legend
            HStack {
                if let hovered = hoveredDay {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.stitchEmerald)
                            .frame(width: 5, height: 5)
                        Text("\(hovered.count) \(viewModel.tr("commits_count")) · \(formattedDate(hovered.date))")
                            .font(.system(size: 10.5, weight: .bold, design: .monospaced))
                            .foregroundColor(Color.stitchEmerald600)
                    }
                } else {
                    Text("\(activeDays.count) \(viewModel.selectedRange.label(language: viewModel.selectedLanguage))")
                        .font(.system(size: 10.5, weight: .medium))
                        .foregroundColor(isDark ? Color.stitchSlate400 : Color.stitchSlate500)
                }

                Spacer()

                // Legend
                HStack(spacing: 4) {
                    Text(viewModel.tr("less"))
                        .font(.system(size: 9.5, weight: .medium))
                        .foregroundColor(isDark ? Color.stitchSlate500 : Color.stitchSlate400)

                    HStack(spacing: 2) {
                        ForEach(0..<5) { level in
                            Rectangle()
                                .fill(theme.grassColor(for: level, isDark: isDark))
                                .frame(width: 8, height: 8)
                                .cornerRadius(1.5)
                        }
                    }

                    Text(viewModel.tr("more"))
                        .font(.system(size: 9.5, weight: .medium))
                        .foregroundColor(isDark ? Color.stitchSlate500 : Color.stitchSlate400)
                }
            }
            .padding(.top, 2)
        }
        .padding(14)
        .stitchCard(isDark: isDark, cornerRadius: 16)
    }

    // MARK: - 4. Floating Action CTA Row
    private var actionCtaRow: some View {
        HStack(spacing: 8) {
            // Live Status Pill
            HStack(spacing: 6) {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Color.stitchIndigo)
                Text("\(viewModel.tr("sync_completed")) (\(viewModel.lastUpdated.replacingOccurrences(of: "Updated ", with: "")))")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(isDark ? Color.stitchSlate300 : Color.stitchSlate700)
                    .lineLimit(1)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isDark ? Color(hex: "151D2A") : Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isDark ? Color.white.opacity(0.1) : Color.stitchSlate200, lineWidth: 1)
            )

            // Primary CTA: View Stats Report Button
            Button(action: {
                withAnimation(.appleSpring(reduceMotion: reduceMotion)) {
                    activeScreen = .stats
                    updatePopoverHeight(500.0)
                }
            }) {
                HStack(spacing: 5) {
                    Text(viewModel.tr("detailed_stats_report"))
                        .font(.system(size: 11.5, weight: .bold))
                        .foregroundColor(.white)

                    Image(systemName: "arrow.right")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(
                    LinearGradient(
                        colors: [Color.stitchIndigo, Color.stitchBlue],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
                .shadow(color: Color.stitchIndigo.opacity(0.35), radius: 5, x: 0, y: 2)
            }
            .buttonStyle(.applePress(scale: 0.96))
        }
    }

    // MARK: - Loading Placeholder
    private var loadingPlaceholderView: some View {
        VStack(spacing: 12) {
            ProgressView()
                .scaleEffect(0.9)
            Text(viewModel.tr("fetching_contributions"))
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(isDark ? Color.stitchSlate400 : Color.stitchSlate500)
        }
        .frame(height: 280)
        .frame(maxWidth: .infinity)
    }

    private func updatePopoverHeight(_ height: CGFloat) {
        NotificationCenter.default.post(
            name: NSNotification.Name("UpdatePopoverSize"),
            object: NSSize(width: 390, height: height)
        )
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일"
        return formatter.string(from: date)
    }
}

// MARK: - View Helpers
extension View {
    func backdropBlur() -> some View {
        self
    }
}
