import SwiftUI
import AppKit
import Combine
import QuartzCore

@main
public class AppDelegate: NSObject, NSApplicationDelegate {
    public var statusItem: NSStatusItem?
    public var popover: NSPopover?
    public let viewModel = AppDIContainer.shared.makeContributionViewModel()
    private var cancellables = Set<AnyCancellable>()

    public static func main() {
        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate
        app.run()
    }

    public func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        if let iconImage = NSImage.appIcon {
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

        NotificationCenter.default.addObserver(forName: NSNotification.Name("UpdatePopoverSize"), object: nil, queue: .main) { [weak self] note in
            if let size = note.object as? NSSize {
                let reduceMotion = NSWorkspace.shared.accessibilityDisplayShouldReduceMotion
                NSAnimationContext.runAnimationGroup { context in
                    context.duration = reduceMotion ? 0.001 : 0.38
                    context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
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

    @objc public func togglePopover() {
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
