import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: ContributionViewModel
    var onBack: () -> Void

    @Environment(\.colorScheme) private var colorScheme
    @State private var currentUsername: String = ""
    @State private var refreshInterval: String = "15 minutes"
    @State private var isSaved: Bool = false

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
                // Header
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
                        .buttonStyle(.plain)
                        .contentShape(Rectangle())

                        Text(viewModel.tr("settings"))
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(theme.textColor(isDark: isDark))
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
                        .background(Color.primaryContainer)
                        .foregroundColor(Color(hex: "004D0F"))
                        .cornerRadius(6)
                    }
                    .buttonStyle(.plain)
                    .contentShape(Rectangle())
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(theme.headerBackgroundColor(isDark: isDark))
                .overlay(Divider().background(theme.strokeColor(isDark: isDark)), alignment: .bottom)

                // Settings Content
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 14) {
                        // GitHub Account Section
                        VStack(alignment: .leading, spacing: 8) {
                            Label(viewModel.tr("github_account"), systemImage: "person.crop.circle")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(theme.textColor(isDark: isDark))

                            VStack(alignment: .leading, spacing: 4) {
                                Text(viewModel.tr("username_saved_auto"))
                                    .font(.system(size: 11))
                                    .foregroundColor(theme.secondaryTextColor(isDark: isDark))
                                
                                TextField(viewModel.tr("username"), text: $currentUsername)
                                    .textFieldStyle(.plain)
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(theme.textColor(isDark: isDark))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(theme.headerBackgroundColor(isDark: isDark))
                                    .cornerRadius(6)
                                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(theme.strokeColor(isDark: isDark), lineWidth: 1))
                            }
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .liquidGlassCard(isDark: isDark, cornerRadius: 10)

                        // Language Selector Section (English, 한국어, 日本語, 中文)
                        VStack(alignment: .leading, spacing: 8) {
                            Label(viewModel.tr("language"), systemImage: "globe")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(theme.textColor(isDark: isDark))

                            HStack(spacing: 6) {
                                ForEach(AppLanguage.allCases) { lang in
                                    Text(lang.displayName)
                                        .font(.system(size: 11, weight: viewModel.selectedLanguage == lang ? .bold : .regular))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                        .background(viewModel.selectedLanguage == lang ? Color.primaryGreen.opacity(0.3) : theme.headerBackgroundColor(isDark: isDark))
                                        .foregroundColor(viewModel.selectedLanguage == lang ? (isDark ? .primaryFixed : Color(hex: "006E1A")) : theme.secondaryTextColor(isDark: isDark))
                                        .cornerRadius(6)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke(viewModel.selectedLanguage == lang ? Color.primaryGreen : theme.strokeColor(isDark: isDark), lineWidth: 1.5)
                                        )
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                viewModel.selectedLanguage = lang
                                            }
                                        }
                                }
                            }
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .liquidGlassCard(isDark: isDark, cornerRadius: 10)

                        // Startup & System Login Section
                        VStack(alignment: .leading, spacing: 8) {
                            Label(viewModel.tr("system_startup"), systemImage: "macwindow.on.rectangle")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(theme.textColor(isDark: isDark))

                            HStack(alignment: .center) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(viewModel.tr("launch_at_login"))
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundColor(theme.textColor(isDark: isDark))
                                    Text(viewModel.tr("launch_at_login_sub"))
                                        .font(.system(size: 9))
                                        .foregroundColor(theme.secondaryTextColor(isDark: isDark))
                                }
                                
                                Spacer(minLength: 12)

                                Toggle("", isOn: $viewModel.autoLaunchAtLogin)
                                    .toggleStyle(.switch)
                                    .labelsHidden()
                                    .tint(isDark ? Color.primaryGreen : Color(hex: "216E39"))
                            }
                            .padding(.vertical, 2)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .liquidGlassCard(isDark: isDark, cornerRadius: 10)

                        // Liquid Glass Appearance Mode Section
                        VStack(alignment: .leading, spacing: 8) {
                            Label(viewModel.tr("appearance_mode"), systemImage: "drop.fill")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(theme.textColor(isDark: isDark))

                            HStack(spacing: 8) {
                                ForEach(AppTheme.allCases) { appTheme in
                                    VStack(spacing: 4) {
                                        Image(systemName: appTheme == .auto ? "desktopcomputer" : (appTheme == .liquidDark ? "moon.fill" : "sun.max.fill"))
                                            .font(.system(size: 14))
                                        Text(viewModel.tr(appTheme.labelKey))
                                            .font(.system(size: 10, weight: viewModel.selectedTheme == appTheme ? .bold : .regular))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(viewModel.selectedTheme == appTheme ? Color.primaryGreen.opacity(0.3) : theme.headerBackgroundColor(isDark: isDark))
                                    .foregroundColor(viewModel.selectedTheme == appTheme ? (isDark ? .primaryFixed : Color(hex: "006E1A")) : theme.secondaryTextColor(isDark: isDark))
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(viewModel.selectedTheme == appTheme ? Color.primaryGreen : theme.strokeColor(isDark: isDark), lineWidth: 1.5)
                                    )
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            viewModel.selectedTheme = appTheme
                                        }
                                    }
                                }
                            }
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .liquidGlassCard(isDark: isDark, cornerRadius: 10)

                        // Data Sync Section
                        VStack(alignment: .leading, spacing: 8) {
                            Label(viewModel.tr("data_sync"), systemImage: "arrow.triangle.2.circlepath")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(theme.textColor(isDark: isDark))

                            HStack {
                                Text(viewModel.tr("refresh_interval"))
                                    .font(.system(size: 11))
                                    .foregroundColor(theme.secondaryTextColor(isDark: isDark))
                                
                                Spacer()

                                Menu {
                                    Button("15 minutes") { refreshInterval = "15 minutes" }
                                    Button("30 minutes") { refreshInterval = "30 minutes" }
                                    Button("1 hour") { refreshInterval = "1 hour" }
                                } label: {
                                    Text(refreshInterval)
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundColor(theme.textColor(isDark: isDark))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(theme.headerBackgroundColor(isDark: isDark))
                                        .cornerRadius(6)
                                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(theme.strokeColor(isDark: isDark), lineWidth: 1))
                                }
                                .menuStyle(.borderlessButton)
                            }
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .liquidGlassCard(isDark: isDark, cornerRadius: 10)

                        // Quit Grassie Section Button
                        Button(action: {
                            NSApplication.shared.terminate(nil)
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "power")
                                    .font(.system(size: 13, weight: .bold))
                                Text("Quit Grassie")
                                    .font(.system(size: 12, weight: .bold))
                            }
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 9)
                            .background(Color.red.opacity(0.12))
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.red.opacity(0.3), lineWidth: 1))
                        }
                        .buttonStyle(.plain)
                        .contentShape(Rectangle())
                        .padding(.top, 4)
                    }
                    .padding(16)
                }
            }
        }
        .frame(width: 380, height: 420)
        .onAppear {
            currentUsername = viewModel.username
        }
    }
}
