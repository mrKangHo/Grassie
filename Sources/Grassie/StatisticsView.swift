import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: ContributionViewModel
    var onBack: () -> Void
    var onOpenSettings: () -> Void
    var onOpenOnboarding: () -> Void

    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedTimeframe: String = "Month"

    private var isDark: Bool {
        viewModel.selectedTheme.isDark(colorScheme: colorScheme)
    }

    private var theme: AppTheme {
        viewModel.selectedTheme
    }

    var body: some View {
        ZStack {
            LiquidGlassBackgroundView(isDark: isDark)

            VStack(spacing: 0) {
                // Header Bar
                HStack {
                    HStack(spacing: 8) {
                        Button(action: onBack) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(theme.textColor(isDark: isDark))
                                .frame(width: 28, height: 28)
                                .background(theme.headerBackgroundColor(isDark: isDark))
                                .clipShape(Circle())
                        }
                        .buttonStyle(.applePress)

                        Text(viewModel.tr("statistics"))
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(theme.textColor(isDark: isDark))
                    }

                    Spacer()

                    // Segmented Timeframe Switcher
                    HStack(spacing: 0) {
                        ForEach(["Week", "Month", "Year"], id: \.self) { tf in
                            Button(action: {
                                withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                                    selectedTimeframe = tf
                                }
                            }) {
                                Text(tf)
                                    .font(.system(size: 10, weight: selectedTimeframe == tf ? .bold : .regular))
                                    .foregroundColor(selectedTimeframe == tf ? .white : theme.secondaryTextColor(isDark: isDark))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(selectedTimeframe == tf ? (isDark ? Color.primaryContainer : Color(hex: "216E39")) : Color.clear)
                                    .cornerRadius(4)
                            }
                            .buttonStyle(.applePress(scale: 0.94))
                        }
                    }
                    .padding(2)
                    .background(theme.headerBackgroundColor(isDark: isDark))
                    .cornerRadius(6)
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(theme.strokeColor(isDark: isDark), lineWidth: 1))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(theme.headerBackgroundColor(isDark: isDark))
                .overlay(Divider().background(theme.strokeColor(isDark: isDark)), alignment: .bottom)

                // Content
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 14) {
                        // User Badge & Quick Links
                        HStack {
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(Color.primaryGreen.opacity(0.2))
                                    .frame(width: 24, height: 24)
                                    .overlay(
                                        Image(systemName: "person.crop.circle.fill")
                                            .font(.system(size: 14))
                                            .foregroundColor(.primaryFixed)
                                    )
                                Text("@\(viewModel.username)")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(theme.textColor(isDark: isDark))
                            }

                            Spacer()

                            Button(action: onOpenSettings) {
                                Image(systemName: "gearshape")
                                    .font(.system(size: 13))
                                    .foregroundColor(theme.secondaryTextColor(isDark: isDark))
                            }
                            .buttonStyle(.applePress)
                        }

                        // Bar Chart Card
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("\(selectedTimeframe)ly Overview")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(theme.textColor(isDark: isDark))
                                Spacer()
                                Text("Live")
                                    .font(.system(size: 9, design: .monospaced))
                                    .foregroundColor(.secondaryFixedDim)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.secondaryBlue.opacity(0.2))
                                    .cornerRadius(8)
                            }

                            // Chart Bars
                            HStack(alignment: .bottom, spacing: 10) {
                                let chartBars = generateTimeframeBars()

                                ForEach(chartBars, id: \.label) { bar in
                                    VStack(spacing: 4) {
                                        RoundedRectangle(cornerRadius: 3)
                                            .fill(bar.isMax ? Color.primaryContainer : (isDark ? Color.primaryGreen.opacity(0.6) : Color(hex: "40C463")))
                                            .frame(height: max(bar.height, 6))
                                            .animation(.spring(response: 0.3, dampingFraction: 0.75), value: bar.height)
                                        Text(bar.label)
                                            .font(.system(size: 9, design: .monospaced))
                                            .foregroundColor(theme.secondaryTextColor(isDark: isDark))
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            .frame(height: 120, alignment: .bottom)
                            .padding(.top, 6)
                        }
                        .padding(12)
                        .liquidGlassCard(isDark: isDark, cornerRadius: 10)

                        // Metrics Cards
                        HStack(spacing: 10) {
                            // Record Card
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Image(systemName: "flame.fill")
                                        .foregroundColor(.primaryFixedDim)
                                        .font(.system(size: 12))
                                    Spacer()
                                    Text("Best Day")
                                        .font(.system(size: 9))
                                        .foregroundColor(theme.secondaryTextColor(isDark: isDark))
                                }
                                HStack(alignment: .firstTextBaseline, spacing: 2) {
                                    Text("\(viewModel.bestDayCount)")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(theme.textColor(isDark: isDark))
                                    Text("commits")
                                        .font(.system(size: 10))
                                        .foregroundColor(isDark ? .primaryFixedDim : Color(hex: "006E1A"))
                                }
                            }
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .liquidGlassCard(isDark: isDark, cornerRadius: 10)

                            // Consistency Card
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Image(systemName: "chart.line.uptrend.xyaxis")
                                        .foregroundColor(.secondaryFixedDim)
                                        .font(.system(size: 12))
                                    Spacer()
                                    Text("Consistency")
                                        .font(.system(size: 9))
                                        .foregroundColor(theme.secondaryTextColor(isDark: isDark))
                                }
                                Text(String(format: "%.1f%%", viewModel.activeConsistency))
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(theme.textColor(isDark: isDark))
                            }
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .liquidGlassCard(isDark: isDark, cornerRadius: 10)
                        }
                    }
                    .padding(16)
                }
            }
        }
        .frame(width: 380, height: 420)
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
