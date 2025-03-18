import Cocoa
import SwiftUI

class QuotePopupManager {
    private static weak var window: QuoteWindow? // Weak reference to prevent memory leaks

    static func showPopup() {
        if let existingWindow = window {
            existingWindow.makeKeyAndOrderFront(nil) // Bring existing window to the front
            return
        }

        let contentView = QuotePopup()

        let newWindow = QuoteWindow(
            contentRect: NSRect(x: 15, y: 900, width: 450, height: 200),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        newWindow.isOpaque = false
        newWindow.backgroundColor = NSColor.clear
        newWindow.contentView = NSHostingView(rootView: contentView)
        newWindow.level = .floating
        newWindow.isReleasedWhenClosed = false
        newWindow.ignoresMouseEvents = false
        newWindow.isMovableByWindowBackground = true
        newWindow.makeKeyAndOrderFront(nil)

        window = newWindow
        NSApp.activate(ignoringOtherApps: true)
    }

    static func closePopup() {
        window?.orderOut(nil) // Hide the popup
        window = nil // Allow it to be freed from memory
    }
}

// ✅ Fix for better macOS window behavior
class QuoteWindow: NSWindow {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
}

