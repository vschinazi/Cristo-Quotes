import Foundation

class QuoteManager {
    private static var lastQuote: String?
    
    static func getRandomQuote() -> String {
        guard let filePath = Bundle.main.path(forResource: "MonteCristoQuotes", ofType: "txt"),
              let quotes = try? String(contentsOfFile: filePath, encoding: .utf8).components(separatedBy: "\n"),
              !quotes.isEmpty else {
            return "There is no greater misfortune than to see one’s enemy victorious."
        }
        
        var newQuote: String
        repeat {
            newQuote = quotes.randomElement() ?? "No quote available."
        } while newQuote == lastQuote  // Prevents repeating the same quote
        
        lastQuote = newQuote
        return newQuote
    }
}

