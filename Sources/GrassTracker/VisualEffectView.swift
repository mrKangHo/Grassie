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
                            ? LinearGradient(colors: [Color.white.opacity(0.3), Color.white.opacity(0.08)], startPoint: .topLeading, endPoint: .bottomTrailing)
                            : LinearGradient(colors: [Color.black.opacity(0.12), Color.black.opacity(0.05)], startPoint: .topLeading, endPoint: .bottomTrailing),
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
}
