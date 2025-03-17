import SwiftUI
import Cocoa

@main
struct MonteCristoQuotesApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        Settings {}  // No visible window
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private var quoteTimer: Timer?
    private var dailyTimers: [Timer] = []
    private var nextQuoteItem: NSMenuItem!

    private enum ScheduleOption: String {
        case every30Seconds = "Every 30 Seconds (Testing)"
        case every30Minutes = "Every 30 Minutes"
        case everyHour = "Every Hour"
        case fixedDailyTimes = "At 09:00, 12:00, 16:00, 20:00, 23:00"
    }

    private var selectedOption: ScheduleOption = .fixedDailyTimes
    private var nextQuoteTime: Date? // Store the next quote time

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenuBar()
        scheduleFixedDailyTimes(hours: [9, 12, 16, 20, 23]) // Default schedule
        updateNextQuoteDisplay()  // Ensure next quote is displayed immediately
    }

    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.button?.image = NSImage(systemSymbolName: "quote.bubble", accessibilityDescription: "Quotes")

        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Show Quote Now", action: #selector(showQuote), keyEquivalent: "S"))
        menu.addItem(.separator())

        let every30SecItem = NSMenuItem(title: ScheduleOption.every30Seconds.rawValue, action: #selector(every30Seconds), keyEquivalent: "")
        let every30MinItem = NSMenuItem(title: ScheduleOption.every30Minutes.rawValue, action: #selector(every30mins), keyEquivalent: "")
        let everyHourItem = NSMenuItem(title: ScheduleOption.everyHour.rawValue, action: #selector(hourly), keyEquivalent: "")
        let fixedTimesItem = NSMenuItem(title: ScheduleOption.fixedDailyTimes.rawValue, action: #selector(fixedDailyTimes), keyEquivalent: "")

        every30SecItem.state = (selectedOption == .every30Seconds) ? .on : .off
        every30MinItem.state = (selectedOption == .every30Minutes) ? .on : .off
        everyHourItem.state = (selectedOption == .everyHour) ? .on : .off
        fixedTimesItem.state = (selectedOption == .fixedDailyTimes) ? .on : .off

        menu.addItem(every30SecItem)
        menu.addItem(every30MinItem)
        menu.addItem(everyHourItem)
        menu.addItem(fixedTimesItem)
        menu.addItem(.separator())

        nextQuoteItem = NSMenuItem(title: "Next Quote: Calculating...", action: nil, keyEquivalent: "")
        nextQuoteItem.isEnabled = false
        menu.addItem(nextQuoteItem)

        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))

        statusItem?.menu = menu

        updateNextQuoteDisplay()
    }

    // MARK: - Scheduling Actions

    @objc func every30Seconds() {
        selectedOption = .every30Seconds
        scheduleRepeatingTimer(interval: 30)
        refreshMenu()
    }

    @objc func every30mins() {
        selectedOption = .every30Minutes
        scheduleRepeatingTimer(interval: 1800)
        refreshMenu()
    }

    @objc func hourly() {
        selectedOption = .everyHour
        scheduleRepeatingTimer(interval: 3600)
        refreshMenu()
    }

    @objc func fixedDailyTimes() {
        selectedOption = .fixedDailyTimes
        scheduleFixedDailyTimes(hours: [9, 12, 16, 20, 23])
        refreshMenu()
    }

    // MARK: - Timer Scheduling Methods

    private func scheduleRepeatingTimer(interval: TimeInterval) {
        quoteTimer?.invalidate()
        dailyTimers.forEach { $0.invalidate() }
        dailyTimers.removeAll()

        nextQuoteTime = Date().addingTimeInterval(interval) // Store the next quote time

        quoteTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            self.showQuote()
        }

        updateNextQuoteDisplay()
    }

    private func scheduleFixedDailyTimes(hours: [Int]) {
        quoteTimer?.invalidate()
        dailyTimers.forEach { $0.invalidate() }
        dailyTimers.removeAll()

        let calendar = Calendar.current
        let now = Date()

        var nextTime: Date?
        for hour in hours {
            if let scheduledTime = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: now),
               scheduledTime > now {
                nextTime = scheduledTime
                break
            }
        }

        if nextTime == nil, let firstTimeTomorrow = calendar.date(bySettingHour: hours.first!, minute: 0, second: 0, of: Calendar.current.date(byAdding: .day, value: 1, to: now)!) {
            nextTime = firstTimeTomorrow
        }

        if let nextTime = nextTime {
            nextQuoteTime = nextTime // Store the next quote time
            let timer = Timer(fireAt: nextTime, interval: 86400, target: self, selector: #selector(showQuote), userInfo: nil, repeats: true)
            RunLoop.main.add(timer, forMode: .common)
            dailyTimers.append(timer)
        }

        updateNextQuoteDisplay()
    }

    // MARK: - Update Next Quote Time in Menu

    private func updateNextQuoteDisplay() {
        let formatter = DateFormatter()
        formatter.timeStyle = .short

        DispatchQueue.main.async {
            if let nextTime = self.nextQuoteTime {
                self.nextQuoteItem.title = "Next Quote: \(formatter.string(from: nextTime))"
            } else {
                self.nextQuoteItem.title = "Next Quote: Error Calculating"
            }
        }
    }

    // MARK: - Basic Actions

    @objc func showQuote() {
        QuotePopupManager.showPopup()
        nextQuoteTime = Date().addingTimeInterval(quoteTimer?.timeInterval ?? 30) // Update next quote time
        updateNextQuoteDisplay()
    }

    @objc func quitApp() {
        NSApp.terminate(nil)
    }

    // MARK: - Refresh Menu
    private func refreshMenu() {
        setupMenuBar()
    }
}

