import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: ContributionViewModel
    var onBack: () -> Void

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var currentUsername: String = ""
    @State private var isSaved: Bool = false

    private func refreshIntervalLabel(_ minutes: Int) -> String {
        switch minutes {
        case 60: return "1 hour"
        default: return "\(minutes) minutes"
        }
    }

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
                // Header
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

                        Text(viewModel.tr("settings"))
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(isDark ? .white : Color.stitchSlate900)
                    }

                    Spacer()

                    Button(action: {
                        viewModel.username = currentUsername
                        isSaved = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            isSaved = false
                        }
                    }) {
                        HStack(spacing: 4) {
                            if isSaved {
                                Image(systemName: "checkmark")
                            }
                            Text(isSaved ? viewModel.tr("saved") : viewModel.tr("save_changes"))
                                .font(.system(size: 11, weight: .bold))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.stitchEmerald)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .shadow(color: Color.stitchEmerald.opacity(0.3), radius: 3, x: 0, y: 1)
                    }
                    .buttonStyle(.applePress)
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

                // Settings Content
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 12) {
                        // GitHub Account Section
                        VStack(alignment: .leading, spacing: 8) {
                            Label(viewModel.tr("github_account"), systemImage: "person.crop.circle")
                                .font(.system(size: 12.5, weight: .bold))
                                .foregroundColor(isDark ? .white : Color.stitchSlate900)

                            VStack(alignment: .leading, spacing: 5) {
                                Text(viewModel.tr("username_saved_auto"))
                                    .font(.system(size: 10.5))
                                    .foregroundColor(isDark ? Color.stitchSlate400 : Color.stitchSlate500)

                                TextField(viewModel.tr("username"), text: $currentUsername)
                                    .textFieldStyle(.plain)
                                    .font(.system(size: 13, weight: .medium, design: .monospaced))
                                    .foregroundColor(isDark ? .white : Color.stitchSlate900)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 7)
                                    .background(isDark ? Color(hex: "1F2937") : Color.stitchSlate50)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(isDark ? Color.white.opacity(0.12) : Color.stitchSlate200, lineWidth: 1)
                                    )
                            }
                        }
                        .padding(14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .stitchCard(isDark: isDark, cornerRadius: 16)

                        // Language Selector Section (English, 한국어, 日本語, 中文)
                        VStack(alignment: .leading, spacing: 8) {
                            Label(viewModel.tr("language"), systemImage: "globe")
                                .font(.system(size: 12.5, weight: .bold))
                                .foregroundColor(isDark ? .white : Color.stitchSlate900)

                            HStack(spacing: 6) {
                                ForEach(AppLanguage.allCases) { lang in
                                    Button(action: {
                                        withAnimation(.appleSpring(response: 0.25, dampingFraction: 0.75, reduceMotion: reduceMotion)) {
                                            viewModel.selectedLanguage = lang
                                        }
                                    }) {
                                        Text(lang.displayName)
                                            .font(.system(size: 11, weight: viewModel.selectedLanguage == lang ? .bold : .medium))
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 7)
                                            .background(
                                                viewModel.selectedLanguage == lang
                                                    ? Color.stitchIndigo
                                                    : (isDark ? Color(hex: "1F2937") : Color.stitchSlate100)
                                            )
                                            .foregroundColor(
                                                viewModel.selectedLanguage == lang
                                                    ? .white
                                                    : (isDark ? Color.stitchSlate300 : Color.stitchSlate700)
                                            )
                                            .cornerRadius(8)
                                    }
                                    .buttonStyle(.applePress(scale: 0.95))
                                }
                            }
                        }
                        .padding(14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .stitchCard(isDark: isDark, cornerRadius: 16)

                        // Startup & System Login Section
                        VStack(alignment: .leading, spacing: 8) {
                            Label(viewModel.tr("system_startup"), systemImage: "macwindow.on.rectangle")
                                .font(.system(size: 12.5, weight: .bold))
                                .foregroundColor(isDark ? .white : Color.stitchSlate900)

                            HStack(alignment: .center) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(viewModel.tr("launch_at_login"))
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundColor(isDark ? .white : Color.stitchSlate800)
                                    Text(viewModel.tr("launch_at_login_sub"))
                                        .font(.system(size: 9.5))
                                        .foregroundColor(isDark ? Color.stitchSlate400 : Color.stitchSlate500)
                                }

                                Spacer(minLength: 12)

                                Toggle("", isOn: $viewModel.autoLaunchAtLogin)
                                    .toggleStyle(.switch)
                                    .labelsHidden()
                                    .tint(Color.stitchEmerald)
                            }
                            .padding(.vertical, 2)
                        }
                        .padding(14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .stitchCard(isDark: isDark, cornerRadius: 16)

                        // Appearance Mode Section
                        VStack(alignment: .leading, spacing: 8) {
                            Label(viewModel.tr("appearance_mode"), systemImage: "paintbrush.fill")
                                .font(.system(size: 12.5, weight: .bold))
                                .foregroundColor(isDark ? .white : Color.stitchSlate900)

                            HStack(spacing: 8) {
                                ForEach(AppTheme.allCases) { appTheme in
                                    Button(action: {
                                        withAnimation(.appleSpring(response: 0.25, dampingFraction: 0.75, reduceMotion: reduceMotion)) {
                                            viewModel.selectedTheme = appTheme
                                        }
                                    }) {
                                        VStack(spacing: 4) {
                                            Image(systemName: appTheme == .auto ? "desktopcomputer" : (appTheme == .liquidDark ? "moon.fill" : "sun.max.fill"))
                                                .font(.system(size: 13))
                                            Text(viewModel.tr(appTheme.labelKey))
                                                .font(.system(size: 10, weight: viewModel.selectedTheme == appTheme ? .bold : .medium))
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 9)
                                        .background(
                                            viewModel.selectedTheme == appTheme
                                                ? Color.stitchIndigo
                                                : (isDark ? Color(hex: "1F2937") : Color.stitchSlate100)
                                        )
                                        .foregroundColor(
                                            viewModel.selectedTheme == appTheme
                                                ? .white
                                                : (isDark ? Color.stitchSlate300 : Color.stitchSlate700)
                                        )
                                        .cornerRadius(8)
                                    }
                                    .buttonStyle(.applePress(scale: 0.95))
                                }
                            }
                        }
                        .padding(14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .stitchCard(isDark: isDark, cornerRadius: 16)

                        // Data Sync Section
                        VStack(alignment: .leading, spacing: 8) {
                            Label(viewModel.tr("data_sync"), systemImage: "arrow.triangle.2.circlepath")
                                .font(.system(size: 12.5, weight: .bold))
                                .foregroundColor(isDark ? .white : Color.stitchSlate900)

                            HStack {
                                Text(viewModel.tr("refresh_interval"))
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(isDark ? Color.stitchSlate400 : Color.stitchSlate500)

                                Spacer()

                                Menu {
                                    Button("15 minutes") { viewModel.refreshIntervalMinutes = 15 }
                                    Button("30 minutes") { viewModel.refreshIntervalMinutes = 30 }
                                    Button("1 hour") { viewModel.refreshIntervalMinutes = 60 }
                                } label: {
                                    Text(refreshIntervalLabel(viewModel.refreshIntervalMinutes))
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundColor(isDark ? .white : Color.stitchSlate800)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(isDark ? Color(hex: "1F2937") : Color.stitchSlate100)
                                        .cornerRadius(6)
                                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(isDark ? Color.white.opacity(0.1) : Color.stitchSlate200, lineWidth: 1))
                                }
                                .menuStyle(.borderlessButton)
                            }
                        }
                        .padding(14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .stitchCard(isDark: isDark, cornerRadius: 16)

                        // Quit Grassie Section Button
                        Button(action: {
                            NSApplication.shared.terminate(nil)
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "power")
                                    .font(.system(size: 12, weight: .bold))
                                Text(viewModel.tr("quit_app"))
                                    .font(.system(size: 11.5, weight: .bold))
                            }
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 9)
                            .background(Color.red.opacity(isDark ? 0.15 : 0.08))
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.red.opacity(0.25), lineWidth: 1))
                        }
                        .buttonStyle(.applePress)
                        .padding(.top, 4)
                    }
                    .padding(16)
                }
            }
        }
        .onAppear {
            currentUsername = viewModel.username
        }
    }
}
