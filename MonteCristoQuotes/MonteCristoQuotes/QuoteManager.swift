import Foundation

class QuoteManager {
    private static let key = "usedQuotesQueue"
    private static var allQuotes: [String] = []

    static func loadQuotes() {
        guard allQuotes.isEmpty,
              let filePath = Bundle.main.path(forResource: "MonteCristoQuotes", ofType: "txt"),
              let quotes = try? String(contentsOfFile: filePath, encoding: .utf8).components(separatedBy: "\n"),
              !quotes.isEmpty else {
            allQuotes = ["There is no greater misfortune than to see one’s enemy victorious."]
            return
        }
        allQuotes = quotes
    }

    static func getRandomQuote() -> String {
        loadQuotes() // Ensure quotes are loaded once

        var quoteQueue = UserDefaults.standard.array(forKey: key) as? [String] ?? []

        if quoteQueue.isEmpty {
            quoteQueue = allQuotes.shuffled()
        }

        let nextQuote = quoteQueue.removeFirst()
        UserDefaults.standard.set(quoteQueue, forKey: key)

        return nextQuote
    }
}

