import Foundation

class QuoteManager {
    private static let key = "usedQuotesQueue"

    static func getRandomQuote() -> String {
        guard let filePath = Bundle.main.path(forResource: "MonteCristoQuotes", ofType: "txt"),
              let quotes = try? String(contentsOfFile: filePath, encoding: .utf8).components(separatedBy: "\n"),
              !quotes.isEmpty else {
            return "There is no greater misfortune than to see one’s enemy victorious."
        }

        var quoteQueue = UserDefaults.standard.array(forKey: key) as? [String] ?? []

        if quoteQueue.isEmpty {
            quoteQueue = quotes.shuffled() // Reset shuffled list when exhausted
        }
        
        let nextQuote = quoteQueue.removeFirst()
        UserDefaults.standard.set(quoteQueue, forKey: key) // Save updated queue
        
        return nextQuote
    }
}

