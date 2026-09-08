import SwiftUI

struct OnboardingView: View {
    var onComplete: (String) -> Void
    var onBack: () -> Void

    @State private var usernameInput: String = ""
    @State private var patInput: String = ""
    @State private var autoLaunch: Bool = true
    @State private var isConnecting: Bool = false

    var body: some View {
        ZStack {
            LiquidGlassBackgroundView(isDark: true)

            VStack(spacing: 0) {
                // Header Bar
                HStack {
                    HStack(spacing: 8) {
                        Button(action: onBack) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 28, height: 28)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                        }
                        .buttonStyle(.applePress)

                        Text("GitHub Setup")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.black.opacity(0.45))
                .overlay(Divider().background(Color.white.opacity(0.15)), alignment: .bottom)

                // Content
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        // Header Icon
                        ZStack {
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.primaryGreen.opacity(0.2))
                                .frame(width: 48, height: 48)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(Color.primaryGreen.opacity(0.4), lineWidth: 1)
                                )
                            Image(systemName: "square.grid.3x3.fill")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.primaryFixedDim)
                        }

                        VStack(spacing: 4) {
                            Text("Connect GitHub Account")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                            Text("Track contribution grass right from your macOS Menu Bar.")
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.6))
                                .multilineTextAlignment(.center)
                        }

                        // Input Form
                        VStack(alignment: .leading, spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("GitHub Username")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.8))
                                TextField("e.g. octocat", text: $usernameInput)
                                    .textFieldStyle(.plain)
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(Color.white.opacity(0.08))
                                    .cornerRadius(6)
                                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.white.opacity(0.2), lineWidth: 1))
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text("Access Token (Optional)")
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.8))
                                    Spacer()
                                    Text("Private repos")
                                        .font(.system(size: 9))
                                        .foregroundColor(.white.opacity(0.4))
                                }
                                SecureField("ghp_xxxxxxxxxxxx", text: $patInput)
                                    .textFieldStyle(.plain)
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(Color.white.opacity(0.08))
                                    .cornerRadius(6)
                                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.white.opacity(0.2), lineWidth: 1))
                            }

                            HStack {
                                Text("Launch at login")
                                    .font(.system(size: 11))
                                    .foregroundColor(.white)
                                Spacer()
                                Toggle("", isOn: $autoLaunch)
                                    .toggleStyle(.switch)
                                    .labelsHidden()
                                    .tint(Color.primaryGreen)
                            }
                            .padding(.vertical, 2)

                            Button(action: {
                                isConnecting = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    isConnecting = false
                                    onComplete(usernameInput.trimmingCharacters(in: .whitespacesAndNewlines))
                                }
                            }) {
                                HStack {
                                    if isConnecting {
                                        ProgressView()
                                            .scaleEffect(0.7)
                                    }
                                    Text(isConnecting ? "Connecting..." : "Connect Account")
                                        .font(.system(size: 12, weight: .bold))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(Color.primaryContainer)
                                .foregroundColor(Color(hex: "004D0F"))
                                .cornerRadius(6)
                            }
                            .buttonStyle(.applePress)
                        }
                        .padding(14)
                        .liquidGlassCard(isDark: true, cornerRadius: 10)
                    }
                    .padding(16)
                }
            }
        }
        .frame(width: 380, height: 420)
    }
}
