import SwiftUI
import AppKit

struct VisualEffectView: NSViewRepresentable {
    var material: NSVisualEffectView.Material = .hudWindow
    var blendingMode: NSVisualEffectView.BlendingMode = .behindWindow

    func makeNSView(context: Context) -> NSVisualEffectView {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
        visualEffectView.state = .active
        return visualEffectView
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}

// Apple Pressable Button Style (Instant response on pointer down, spring velocity)
struct ApplePressableButtonStyle: ButtonStyle {
    var scale: CGFloat = 0.96
    var opacity: Double = 0.88

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1.0)
            .opacity(configuration.isPressed ? opacity : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == ApplePressableButtonStyle {
    static var applePress: ApplePressableButtonStyle {
        ApplePressableButtonStyle()
    }
    static func applePress(scale: CGFloat = 0.96, opacity: Double = 0.88) -> ApplePressableButtonStyle {
        ApplePressableButtonStyle(scale: scale, opacity: opacity)
    }
}

// Critically-damped-by-default spring that degrades to a short cross-fade
// when the user has Reduce Motion enabled (System Settings > Accessibility).
extension Animation {
    static func appleSpring(response: Double = 0.35, dampingFraction: Double = 0.82, reduceMotion: Bool) -> Animation {
        reduceMotion ? .easeInOut(duration: 0.15) : .spring(response: response, dampingFraction: dampingFraction)
    }
}

// A push/pop screen transition that slides in from `edge` and exits back
// along the same edge (symmetric path), or falls back to a plain cross-fade
// under Reduce Motion.
extension AnyTransition {
    static func applePush(edge: Edge, reduceMotion: Bool) -> AnyTransition {
        guard !reduceMotion else { return .opacity }
        return .asymmetric(
            insertion: .move(edge: edge).combined(with: .opacity),
            removal: .move(edge: edge).combined(with: .opacity)
        )
    }
}

struct LiquidGlassBackgroundView: View {
    var isDark: Bool = true

    var body: some View {
        ZStack {
            // Real macOS Translucent Window Blur
            VisualEffectView(
                material: isDark ? .hudWindow : .headerView,
                blendingMode: .behindWindow
            )

            if isDark {
                // Dark Liquid Caustic Radial Lights
                RadialGradient(
                    colors: [Color.primaryContainer.opacity(0.15), Color.clear],
                    center: .topLeading,
                    startRadius: 20,
                    endRadius: 280
                )

                RadialGradient(
                    colors: [Color.secondaryBlue.opacity(0.12), Color.clear],
                    center: .bottomTrailing,
                    startRadius: 20,
                    endRadius: 300
                )

                LinearGradient(
                    colors: [
                        Color.white.opacity(0.14),
                        Color.white.opacity(0.03),
                        Color.clear
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            } else {
                // Light Liquid Caustic Radial Lights
                RadialGradient(
                    colors: [Color.primaryContainer.opacity(0.2), Color.clear],
                    center: .topLeading,
                    startRadius: 20,
                    endRadius: 280
                )

                RadialGradient(
                    colors: [Color.secondaryBlue.opacity(0.15), Color.clear],
                    center: .bottomTrailing,
                    startRadius: 20,
                    endRadius: 300
                )

                LinearGradient(
                    colors: [
                        Color.white.opacity(0.6),
                        Color.white.opacity(0.1),
                        Color.clear
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
    }
}

struct LiquidGlassCardModifier: ViewModifier {
    var isDark: Bool = true
    var cornerRadius: CGFloat = 10

    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    if isDark {
                        Color.black.opacity(0.35)
                        LinearGradient(
                            colors: [Color.white.opacity(0.12), Color.clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    } else {
                        Color.white.opacity(0.85)
                        LinearGradient(
                            colors: [Color.white.opacity(0.9), Color.white.opacity(0.6)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }
                }
            )
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        isDark
                            ? LinearGradient(colors: [Color.white.opacity(0.28), Color.white.opacity(0.06)], startPoint: .topLeading, endPoint: .bottomTrailing)
                            : LinearGradient(colors: [Color.black.opacity(0.12), Color.black.opacity(0.04)], startPoint: .topLeading, endPoint: .bottomTrailing),
                        lineWidth: 1
                    )
            )
            .shadow(color: isDark ? Color.black.opacity(0.3) : Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}

extension View {
    func liquidGlassCard(isDark: Bool = true, cornerRadius: CGFloat = 10) -> some View {
        self.modifier(LiquidGlassCardModifier(isDark: isDark, cornerRadius: cornerRadius))
    }

    func stitchCard(isDark: Bool = false, cornerRadius: CGFloat = 16) -> some View {
        self.modifier(StitchCardModifier(isDark: isDark, cornerRadius: cornerRadius))
    }
}

// MARK: - Stitch Modern Card Modifier
struct StitchCardModifier: ViewModifier {
    var isDark: Bool = false
    var cornerRadius: CGFloat = 16

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(isDark ? Color(hex: "151D2A").opacity(0.9) : Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        isDark ? Color.white.opacity(0.12) : Color(hex: "E2E8F0").opacity(0.95),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: isDark ? Color.black.opacity(0.3) : Color(hex: "0F172A").opacity(0.04),
                radius: 10,
                x: 0,
                y: 4
            )
    }
}

// MARK: - Stitch Ambient Glow View
struct StitchAmbientGlowView: View {
    var isDark: Bool = false

    var body: some View {
        ZStack {
            // Top Ambient Light Blob
            Circle()
                .fill(
                    RadialGradient(
                        colors: isDark
                            ? [Color(hex: "4F46E5").opacity(0.18), Color(hex: "2563EB").opacity(0.10), Color.clear]
                            : [Color(hex: "818CF8").opacity(0.20), Color(hex: "93C5FD").opacity(0.15), Color.clear],
                        center: .center,
                        startRadius: 10,
                        endRadius: 180
                    )
                )
                .frame(width: 320, height: 320)
                .offset(y: -150)
                .blur(radius: 40)

            // Bottom Right Emerald Glow Blob
            Circle()
                .fill(
                    RadialGradient(
                        colors: isDark
                            ? [Color(hex: "10B981").opacity(0.15), Color.clear]
                            : [Color(hex: "6EE7B7").opacity(0.22), Color.clear],
                        center: .center,
                        startRadius: 10,
                        endRadius: 160
                    )
                )
                .frame(width: 260, height: 260)
                .offset(x: 110, y: 160)
                .blur(radius: 45)
        }
        .allowsHitTesting(false)
    }
}


