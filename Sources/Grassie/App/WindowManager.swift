import SwiftUI
import AppKit

extension NSImage {
    public static var appIcon: NSImage? {
        if let image = NSImage(named: "AppIcon") {
            return image
        }
        if let resourcePath = Bundle.main.path(forResource: "AppIcon", ofType: "icns"),
           let image = NSImage(contentsOfFile: resourcePath) {
            return image
        }
        #if SWIFT_PACKAGE
        if let resourcePath = Bundle.module.path(forResource: "AppIcon", ofType: "icns"),
           let image = NSImage(contentsOfFile: resourcePath) {
            return image
        }
        #endif
        return nil
    }
}

public final class WindowManager: ObservableObject {
    public static let shared = WindowManager()

    private var settingsWindow: NSWindow?
    private var statsWindow: NSWindow?
    private var onboardingWindow: NSWindow?

    public func openSettings(viewModel: ContributionViewModel) {
        if let window = settingsWindow, window.isVisible {
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        let settingsView = SettingsView(
            viewModel: viewModel,
            onBack: { [weak self] in
                self?.settingsWindow?.orderOut(nil)
            }
        )

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 440),
            styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.center()
        window.title = "Grassie Settings"
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = true
        window.contentViewController = NSHostingController(rootView: settingsView)
        window.isReleasedWhenClosed = false

        if let iconImage = NSImage.appIcon {
            window.miniwindowImage = iconImage
        }

        self.settingsWindow = window
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    public func openStats(viewModel: ContributionViewModel) {
        if let window = statsWindow, window.isVisible {
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        let statsView = StatisticsView(
            viewModel: viewModel,
            onBack: { [weak self] in
                self?.statsWindow?.orderOut(nil)
            },
            onOpenSettings: { [weak self] in
                self?.statsWindow?.orderOut(nil)
                self?.openSettings(viewModel: viewModel)
            },
            onOpenOnboarding: { [weak self] in
                self?.statsWindow?.orderOut(nil)
                self?.openOnboarding(viewModel: viewModel)
            }
        )

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 720, height: 480),
            styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.center()
        window.title = "Grassie - Detailed Statistics"
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = true
        window.contentViewController = NSHostingController(rootView: statsView)
        window.isReleasedWhenClosed = false

        if let iconImage = NSImage.appIcon {
            window.miniwindowImage = iconImage
        }

        self.statsWindow = window
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    public func openOnboarding(viewModel: ContributionViewModel) {
        if let window = onboardingWindow, window.isVisible {
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        let onboardingView = OnboardingView(
            onComplete: { [weak self] newUsername in
                viewModel.username = newUsername
                self?.onboardingWindow?.orderOut(nil)
            },
            onBack: { [weak self] in
                self?.onboardingWindow?.orderOut(nil)
            }
        )

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 440, height: 460),
            styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.center()
        window.title = "Grassie Setup"
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = true
        window.contentViewController = NSHostingController(rootView: onboardingView)
        window.isReleasedWhenClosed = false

        if let iconImage = NSImage.appIcon {
            window.miniwindowImage = iconImage
        }

        self.onboardingWindow = window
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
