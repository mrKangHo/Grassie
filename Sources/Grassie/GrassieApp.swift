import SwiftUI
import AppKit
import Combine

class WindowManager: ObservableObject {
    static let shared = WindowManager()

    private var settingsWindow: NSWindow?
    private var statsWindow: NSWindow?
    private var onboardingWindow: NSWindow?

    func openSettings(viewModel: ContributionViewModel) {
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

        if let iconImage = NSImage(contentsOfFile: "/Users/lee/Documents/githubBar/grasstracker_app_icon.jpg") {
            window.miniwindowImage = iconImage
        }

        self.settingsWindow = window
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    func openStats(viewModel: ContributionViewModel) {
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

        if let iconImage = NSImage(contentsOfFile: "/Users/lee/Documents/githubBar/grasstracker_app_icon.jpg") {
            window.miniwindowImage = iconImage
        }

        self.statsWindow = window
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    func openOnboarding(viewModel: ContributionViewModel) {
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

        self.onboardingWindow = window
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover?
    let viewModel = ContributionViewModel()
    private var cancellables = Set<AnyCancellable>()

    static func main() {
        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate
        app.run()
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        let iconPath = "/Users/lee/Documents/githubBar/grasstracker_app_icon.jpg"
        if let iconImage = NSImage(contentsOfFile: iconPath) {
            NSApp.applicationIconImage = iconImage
        } else if let resourcePath = Bundle.main.path(forResource: "AppIcon", ofType: "icns"),
                  let iconImage = NSImage(contentsOfFile: resourcePath) {
            NSApp.applicationIconImage = iconImage
        }

        let popover = NSPopover()
        popover.contentSize = NSSize(width: 380, height: 420)
        popover.behavior = .transient
        popover.animates = true

        let popoverView = MainPopoverView(
            viewModel: viewModel,
            onOpenStats: { [weak self] in
                guard let self = self else { return }
                self.popover?.performClose(nil)
                WindowManager.shared.openStats(viewModel: self.viewModel)
            },
            onOpenSettings: { [weak self] in
                guard let self = self else { return }
                self.popover?.performClose(nil)
                WindowManager.shared.openSettings(viewModel: self.viewModel)
            }
        )

        popover.contentViewController = NSHostingController(rootView: popoverView)
        self.popover = popover

        // Observe popover size update requests
        NotificationCenter.default.addObserver(forName: NSNotification.Name("UpdatePopoverSize"), object: nil, queue: .main) { [weak self] note in
            if let size = note.object as? NSSize {
                NSAnimationContext.runAnimationGroup { context in
                    context.duration = 0.2
                    self?.popover?.contentSize = size
                }
            }
        }

        // Initialize status bar item with dynamic 3x3 grass icon
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem?.button {
            button.image = DynamicGrassIconGenerator.createIcon(days: viewModel.days)
            button.action = #selector(togglePopover)
            button.target = self
        }

        // Reactive Combine listeners: Update icon and title live when data fetches or settings change
        viewModel.$days
            .receive(on: DispatchQueue.main)
            .sink { [weak self] days in
                guard let self = self else { return }
                self.updateStatusItem(days: days, streak: self.viewModel.currentStreak)
            }
            .store(in: &cancellables)

        viewModel.$currentStreak
            .receive(on: DispatchQueue.main)
            .sink { [weak self] streak in
                guard let self = self else { return }
                self.updateStatusItem(days: self.viewModel.days, streak: streak)
            }
            .store(in: &cancellables)

        viewModel.$username
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.updateStatusItem(days: self.viewModel.days, streak: self.viewModel.currentStreak)
            }
            .store(in: &cancellables)

        viewModel.$selectedLanguage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.updateStatusItem(days: self.viewModel.days, streak: self.viewModel.currentStreak)
            }
            .store(in: &cancellables)
    }

    private func updateStatusItem(days: [ContributionDay], streak: Int) {
        if let button = statusItem?.button {
            button.image = DynamicGrassIconGenerator.createIcon(days: days)
            if viewModel.username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                button.title = " Grassie 🌱"
            } else {
                let localizedStreak = L10n.streakText(count: streak, language: viewModel.selectedLanguage)
                button.title = " \(localizedStreak) \(viewModel.streakBadgeEmoji)"
            }
        }
    }

    @objc func togglePopover() {
        guard let button = statusItem?.button, let popover = popover else { return }
        if popover.isShown {
            popover.performClose(nil)
        } else {
            updateStatusItem(days: viewModel.days, streak: viewModel.currentStreak)
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            DispatchQueue.main.async {
                NSApp.activate(ignoringOtherApps: true)
                popover.contentViewController?.view.window?.makeKeyAndOrderFront(nil)
            }
        }
    }
}
