import Cocoa
import SwiftUI

class QuotePopupManager {
    static var window: QuoteWindow?

    static func showPopup() {
        if window != nil {  // Prevent duplicate popups
            return
        }

        let contentView = QuotePopup()

        let window = QuoteWindow(
            contentRect: NSRect(x: 15, y: 900, width: 450, height: 200),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        window.isOpaque = false
        window.backgroundColor = NSColor.clear
        window.contentView = NSHostingView(rootView: contentView)
        window.level = .floating
        window.isReleasedWhenClosed = false
        window.ignoresMouseEvents = false
        window.isMovableByWindowBackground = true
        window.makeKeyAndOrderFront(nil)

        self.window = window  // Store reference to the popup window
        NSApp.activate(ignoringOtherApps: true)  // Ensure the app remains active
    }

    static func closePopup() {
        window?.orderOut(nil)  // Hide the popup instead of fully closing it
        window = nil  // Remove reference to allow reopening
        NSApp.activate(ignoringOtherApps: true)  // Keep the app active to retain menu bar visibility
    }
}

// Custom NSWindow subclass to allow it to become key
class QuoteWindow: NSWindow {
    override var canBecomeKey: Bool {
        return true
    }
}

