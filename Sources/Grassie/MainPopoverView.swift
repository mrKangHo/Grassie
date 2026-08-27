import SwiftUI

struct MainPopoverView: View {
    @ObservedObject var viewModel: ContributionViewModel
    var onOpenStats: () -> Void
    var onOpenSettings: () -> Void

    @Environment(\.colorScheme) private var colorScheme
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
            return 4.5
        case .threeMonths:
            return 3.5
        default:
            return 2.0
        }
    }

    private var targetPopoverHeight: CGFloat {
        switch viewModel.selectedRange {
        case .oneMonth:
            return 580.0
        case .threeMonths:
            return 485.0
        case .sixMonths:
            return 445.0
        case .oneYear:
            return 420.0
        }
    }

    private var gridHeight: CGFloat {
        return (cellSize * 7) + (cellSpacing * 6) + 4
    }

    var body: some View {
        ZStack {
            // Liquid Glass Translucent Blur
            LiquidGlassBackgroundView(isDark: isDark)

            VStack(spacing: 0) {
                // Header
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "square.grid.3x3.fill")
                            .foregroundColor(.primaryFixedDim)
                            .font(.system(size: 16, weight: .bold))

                        Text("Grassie")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(theme.textColor(isDark: isDark))

                        Button(action: {
                            if let url = URL(string: "https://github.com/\(viewModel.username)") {
                                NSWorkspace.shared.open(url)
                            }
                        }) {
                            Text("@\(viewModel.username)")
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .padding(.horizontal, 7)
                                .padding(.vertical, 3)
                                .background(Color.primaryGreen.opacity(0.45))
                                .foregroundColor(isDark ? .primaryFixed : .white)
                                .cornerRadius(5)
                        }
                        .buttonStyle(.plain)
                        .contentShape(Rectangle())
                    }

                    Spacer()

                    HStack(spacing: 8) {
                        // Settings Gear Button
                        Button(action: {
                            onOpenSettings()
                        }) {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 15))
                                .foregroundColor(theme.textColor(isDark: isDark))
                                .padding(7)
                                .background(theme.headerBackgroundColor(isDark: isDark))
                                .clipShape(Circle())
                                .overlay(Circle().stroke(theme.strokeColor(isDark: isDark), lineWidth: 1))
                        }
                        .buttonStyle(.plain)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            onOpenSettings()
                        }

                        // Quit App Button
                        Button(action: {
                            NSApplication.shared.terminate(nil)
                        }) {
                            Image(systemName: "power")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color.red.opacity(0.9))
                                .padding(7)
                                .background(Color.red.opacity(0.12))
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.red.opacity(0.3), lineWidth: 1))
                        }
                        .buttonStyle(.plain)
                        .contentShape(Rectangle())
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(theme.headerBackgroundColor(isDark: isDark))
                .overlay(Divider().background(theme.strokeColor(isDark: isDark)), alignment: .bottom)

                // Content Area
                VStack(spacing: 16) {
                    if viewModel.isLoading && viewModel.days.isEmpty {
                        VStack(spacing: 12) {
                            ProgressView()
                                .scaleEffect(0.9)
                            Text(viewModel.tr("fetching_contributions"))
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(theme.secondaryTextColor(isDark: isDark))
                        }
                        .frame(maxHeight: .infinity)
                    } else {
                        // Summary Stats Cards
                        HStack(spacing: 12) {
                            // Current Streak Card
                            VStack(alignment: .leading, spacing: 4) {
                                Text(viewModel.tr("current_streak").uppercased())
                                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                                    .foregroundColor(theme.secondaryTextColor(isDark: isDark))
                                HStack(alignment: .firstTextBaseline, spacing: 3) {
                                    Text("\(viewModel.currentStreak)")
                                        .font(.system(size: 26, weight: .heavy))
                                        .foregroundColor(theme.textColor(isDark: isDark))
                                    Text(viewModel.tr("days"))
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(isDark ? .primaryFixedDim : Color(hex: "006E1A"))
                                }
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .liquidGlassCard(isDark: isDark, cornerRadius: 10)

                            // Total Contributions Card
                            VStack(alignment: .leading, spacing: 4) {
                                Text(viewModel.tr("total_contributions").uppercased())
                                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                                    .foregroundColor(theme.secondaryTextColor(isDark: isDark))
                                Text("\(viewModel.totalContributions)")
                                    .font(.system(size: 26, weight: .heavy))
                                    .foregroundColor(theme.textColor(isDark: isDark))
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .liquidGlassCard(isDark: isDark, cornerRadius: 10)
                        }

                        // Contribution Grid Section Card
                        VStack(alignment: .leading, spacing: 10) {
                            // Period Filter Picker Bar
                            HStack {
                                Text(viewModel.tr("contribution_graph"))
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(theme.textColor(isDark: isDark))

                                Spacer()

                                // Range Switcher (1M, 3M, 6M, 1Y)
                                HStack(spacing: 2) {
                                    ForEach(TimeframeRange.allCases) { range in
                                        Text(range.rawValue)
                                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                                            .foregroundColor(viewModel.selectedRange == range ? .white : theme.secondaryTextColor(isDark: isDark))
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(viewModel.selectedRange == range ? (isDark ? Color.primaryContainer : Color(hex: "216E39")) : Color.clear)
                                            .cornerRadius(5)
                                            .onTapGesture {
                                                withAnimation(.easeInOut(duration: 0.2)) {
                                                    viewModel.selectedRange = range
                                                    updateWindowSize(for: range)
                                                }
                                            }
                                    }
                                }
                                .padding(2)
                                .background(theme.headerBackgroundColor(isDark: isDark))
                                .cornerRadius(7)
                                .overlay(RoundedRectangle(cornerRadius: 7).stroke(theme.strokeColor(isDark: isDark), lineWidth: 1))
                            }

                            // Filtered Grid Cells
                            let activeDays = viewModel.filteredDays(for: viewModel.selectedRange)

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
                                            .scaleEffect(hoveredDay?.id == day.id ? 1.25 : 1.0)
                                            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: hoveredDay?.id == day.id)
                                            .onHover { isHovered in
                                                if isHovered {
                                                    hoveredDay = day
                                                }
                                            }
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                            .frame(height: gridHeight)
                            .frame(maxWidth: .infinity, alignment: .center)

                            // Tooltip & Legend Bar
                            HStack {
                                if let hovered = hoveredDay {
                                    Text("\(hovered.count) \(formattedDate(hovered.date))")
                                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                                        .foregroundColor(isDark ? .primaryFixedDim : Color(hex: "216E39"))
                                } else {
                                    Text("\(activeDays.count) \(viewModel.selectedRange.label(language: viewModel.selectedLanguage))")
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundColor(theme.secondaryTextColor(isDark: isDark))
                                }

                                Spacer()

                                // Legend
                                HStack(spacing: 5) {
                                    Text(viewModel.tr("less"))
                                        .font(.system(size: 10, weight: .medium))
                                        .foregroundColor(theme.secondaryTextColor(isDark: isDark))
                                    HStack(spacing: 2.5) {
                                        ForEach(0..<5) { level in
                                            Rectangle()
                                                .fill(theme.grassColor(for: level, isDark: isDark))
                                                .frame(width: 9, height: 9)
                                                .cornerRadius(1.5)
                                                .overlay(RoundedRectangle(cornerRadius: 1.5).stroke(theme.grassBorderColor(for: level, isDark: isDark), lineWidth: 0.5))
                                        }
                                    }
                                    Text(viewModel.tr("more"))
                                        .font(.system(size: 10, weight: .medium))
                                        .foregroundColor(theme.secondaryTextColor(isDark: isDark))
                                }
                            }
                        }
                        .padding(12)
                        .liquidGlassCard(isDark: isDark, cornerRadius: 10)
                    }
                }
                .padding(16)
                .frame(maxHeight: .infinity, alignment: .top)

                Spacer(minLength: 0)

                // Footer Controls
                HStack {
                    Button(action: {
                        viewModel.refresh()
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 12, weight: .bold))
                                .rotationEffect(.degrees(viewModel.isRefreshing ? 360 : 0))
                                .animation(viewModel.isRefreshing ? .linear(duration: 1).repeatForever(autoreverses: false) : .default, value: viewModel.isRefreshing)
                            Text(viewModel.lastUpdated)
                                .font(.system(size: 11, weight: .semibold))
                        }
                        .foregroundColor(theme.textColor(isDark: isDark))
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(theme.headerBackgroundColor(isDark: isDark))
                        .cornerRadius(6)
                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(theme.strokeColor(isDark: isDark), lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.refresh()
                    }

                    Spacer()

                    Button(action: {
                        onOpenStats()
                    }) {
                        HStack(spacing: 5) {
                            Text(viewModel.tr("view_full_stats"))
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                            Image(systemName: "arrow.right")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(Color.secondaryBlue)
                        .cornerRadius(6)
                        .shadow(color: Color.secondaryBlue.opacity(0.4), radius: 4, x: 0, y: 2)
                    }
                    .buttonStyle(.plain)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        onOpenStats()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(theme.headerBackgroundColor(isDark: isDark))
                .overlay(Divider().background(theme.strokeColor(isDark: isDark)), alignment: .top)
            }
        }
        .frame(width: 380, height: targetPopoverHeight)
        .onAppear {
            updateWindowSize(for: viewModel.selectedRange)
        }
    }

    private func updateWindowSize(for range: TimeframeRange) {
        let height: CGFloat
        switch range {
        case .oneMonth: height = 580.0
        case .threeMonths: height = 485.0
        case .sixMonths: height = 445.0
        case .oneYear: height = 420.0
        }
        NotificationCenter.default.post(name: NSNotification.Name("UpdatePopoverSize"), object: NSSize(width: 380, height: height))
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}
