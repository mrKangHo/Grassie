import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: ContributionViewModel
    var onBack: () -> Void
    var onOpenSettings: () -> Void
    var onOpenOnboarding: () -> Void

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var selectedTimeframe: String = "Month"

    private var isDark: Bool {
        viewModel.selectedTheme.isDark(colorScheme: colorScheme)
    }

    private var theme: AppTheme {
        viewModel.selectedTheme
    }

    var body: some View {
        ZStack {
            VisualEffectView(
                material: isDark ? .hudWindow : .headerView,
                blendingMode: .behindWindow
            )

            StitchAmbientGlowView(isDark: isDark)

            VStack(spacing: 0) {
                // Header Bar
                HStack {
                    HStack(spacing: 8) {
                        Button(action: onBack) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(isDark ? .white : Color.stitchSlate800)
                                .frame(width: 28, height: 28)
                                .background(isDark ? Color(hex: "1F2937") : Color.white)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(isDark ? Color.white.opacity(0.12) : Color.stitchSlate200, lineWidth: 1))
                        }
                        .buttonStyle(.applePress)

                        Text(viewModel.tr("view_full_stats"))
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(isDark ? .white : Color.stitchSlate900)
                    }

                    Spacer()

                    // Segmented Timeframe Switcher
                    HStack(spacing: 2) {
                        ForEach(["Week", "Month", "Year"], id: \.self) { tf in
                            Button(action: {
                                withAnimation(.appleSpring(response: 0.25, dampingFraction: 0.75, reduceMotion: reduceMotion)) {
                                    selectedTimeframe = tf
                                }
                            }) {
                                Text(tf)
                                    .font(.system(size: 10.5, weight: selectedTimeframe == tf ? .bold : .medium))
                                    .foregroundColor(
                                        selectedTimeframe == tf
                                            ? Color.stitchIndigo
                                            : (isDark ? Color.stitchSlate400 : Color.stitchSlate500)
                                    )
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3.5)
                                    .background(
                                        selectedTimeframe == tf
                                            ? (isDark ? Color(hex: "1F2937") : Color.white)
                                            : Color.clear
                                    )
                                    .cornerRadius(6)
                                    .shadow(
                                        color: selectedTimeframe == tf ? Color.black.opacity(isDark ? 0.2 : 0.04) : Color.clear,
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
                    .cornerRadius(8)
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

                // Content
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 12) {
                        // User Badge & Quick Links
                        HStack {
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(Color.stitchEmerald.opacity(0.15))
                                    .frame(width: 26, height: 26)
                                    .overlay(
                                        Image(systemName: "person.crop.circle.fill")
                                            .font(.system(size: 15))
                                            .foregroundColor(Color.stitchEmerald)
                                    )
                                Text("@\(viewModel.username)")
                                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                                    .foregroundColor(isDark ? .white : Color.stitchSlate900)
                            }

                            Spacer()

                            Button(action: onOpenSettings) {
                                Image(systemName: "gearshape")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(isDark ? Color.stitchSlate400 : Color.stitchSlate600)
                                    .frame(width: 28, height: 28)
                                    .background(isDark ? Color(hex: "1F2937") : Color.white)
                                    .cornerRadius(8)
                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(isDark ? Color.white.opacity(0.1) : Color.stitchSlate200, lineWidth: 1))
                            }
                            .buttonStyle(.applePress)
                        }

                        // Bar Chart Card
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("\(selectedTimeframe)ly Activity Overview")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(isDark ? .white : Color.stitchSlate900)
                                Spacer()
                                Text(viewModel.tr("live_synced"))
                                    .font(.system(size: 9.5, weight: .bold, design: .monospaced))
                                    .foregroundColor(Color.stitchEmerald600)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.stitchEmerald.opacity(0.12))
                                    .cornerRadius(6)
                            }

                            // Chart Bars
                            HStack(alignment: .bottom, spacing: 10) {
                                let chartBars = generateTimeframeBars()

                                ForEach(chartBars, id: \.label) { bar in
                                    VStack(spacing: 4) {
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(
                                                bar.isMax
                                                    ? LinearGradient(colors: [Color.stitchIndigo, Color.stitchBlue], startPoint: .top, endPoint: .bottom)
                                                    : LinearGradient(colors: [Color.stitchEmerald.opacity(0.85), Color.stitchEmerald600], startPoint: .top, endPoint: .bottom)
                                            )
                                            .frame(height: max(bar.height, 6))
                                            .animation(.appleSpring(response: 0.3, dampingFraction: 0.75, reduceMotion: reduceMotion), value: bar.height)
                                        Text(bar.label)
                                            .font(.system(size: 9, weight: .semibold, design: .monospaced))
                                            .foregroundColor(isDark ? Color.stitchSlate400 : Color.stitchSlate500)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            .frame(height: 120, alignment: .bottom)
                            .padding(.top, 6)
                        }
                        .padding(14)
                        .stitchCard(isDark: isDark, cornerRadius: 16)

                        // Metrics Cards
                        HStack(spacing: 10) {
                            // Record Card
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Image(systemName: "flame.fill")
                                        .foregroundColor(Color.stitchAmber500)
                                        .font(.system(size: 12))
                                    Spacer()
                                    Text("Best Day")
                                        .font(.system(size: 10, weight: .medium))
                                        .foregroundColor(isDark ? Color.stitchSlate400 : Color.stitchSlate500)
                                }
                                HStack(alignment: .firstTextBaseline, spacing: 2) {
                                    Text("\(viewModel.bestDayCount)")
                                        .font(.system(size: 22, weight: .heavy, design: .rounded))
                                        .foregroundColor(isDark ? .white : Color.stitchSlate900)
                                    Text(viewModel.tr("commits_count"))
                                        .font(.system(size: 10.5, weight: .semibold))
                                        .foregroundColor(Color.stitchEmerald600)
                                }
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .stitchCard(isDark: isDark, cornerRadius: 14)

                            // Consistency Card
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Image(systemName: "chart.line.uptrend.xyaxis")
                                        .foregroundColor(Color.stitchIndigo)
                                        .font(.system(size: 12))
                                    Spacer()
                                    Text(viewModel.tr("consistency_rate"))
                                        .font(.system(size: 10, weight: .medium))
                                        .foregroundColor(isDark ? Color.stitchSlate400 : Color.stitchSlate500)
                                }
                                Text(String(format: "%.1f%%", viewModel.activeConsistency))
                                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                                    .foregroundColor(isDark ? .white : Color.stitchSlate900)
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .stitchCard(isDark: isDark, cornerRadius: 14)
                        }
                    }
                    .padding(16)
                }
            }
        }
    }

    private func generateTimeframeBars() -> [(label: String, height: CGFloat, isMax: Bool)] {
        if selectedTimeframe == "Week" {
            let labels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
            let counts = Array(viewModel.days.suffix(7)).map { CGFloat($0.count) }
            let maxVal = max(counts.max() ?? 1.0, 1.0)
            return labels.enumerated().map { idx, label in
                let val = idx < counts.count ? counts[idx] : 0
                return (label: label, height: (val / maxVal) * 80 + 6, isMax: val == maxVal && val > 0)
            }
        } else if selectedTimeframe == "Month" {
            let labels = ["W1", "W2", "W3", "W4", "W5"]
            let total = viewModel.days.count
            let chunkSize = max(total / 5, 1)
            var barHeights: [CGFloat] = []
            for i in 0..<5 {
                let start = max(total - (5 - i) * chunkSize, 0)
                let end = min(start + chunkSize, total)
                if start < end {
                    let sum = viewModel.days[start..<end].reduce(0) { $0 + $1.count }
                    barHeights.append(CGFloat(sum))
                } else {
                    barHeights.append(0)
                }
            }
            let maxVal = max(barHeights.max() ?? 1.0, 1.0)
            return labels.enumerated().map { idx, label in
                let val = barHeights[idx]
                return (label: label, height: (val / maxVal) * 80 + 6, isMax: val == maxVal && val > 0)
            }
        } else {
            let labels = ["Q1", "Q2", "Q3", "Q4"]
            let total = viewModel.days.count
            let chunkSize = max(total / 4, 1)
            var barHeights: [CGFloat] = []
            for i in 0..<4 {
                let start = max(total - (4 - i) * chunkSize, 0)
                let end = min(start + chunkSize, total)
                if start < end {
                    let sum = viewModel.days[start..<end].reduce(0) { $0 + $1.count }
                    barHeights.append(CGFloat(sum))
                } else {
                    barHeights.append(0)
                }
            }
            let maxVal = max(barHeights.max() ?? 1.0, 1.0)
            return labels.enumerated().map { idx, label in
                let val = barHeights[idx]
                return (label: label, height: (val / maxVal) * 80 + 6, isMax: val == maxVal && val > 0)
            }
        }
    }
}
