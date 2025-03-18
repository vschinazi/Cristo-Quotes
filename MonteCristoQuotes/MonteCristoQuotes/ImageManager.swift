import Foundation

class ImageManager {
    private static let key = "usedImagesQueue"
    
    static func getRandomImage() -> String {
        var imageQueue = UserDefaults.standard.array(forKey: key) as? [String] ?? []
        
        if imageQueue.isEmpty {
            imageQueue = (1...50).map { "image\($0)" } // Reset list
            imageQueue.shuffle()
        }
        
        let nextImage = imageQueue.removeFirst()
        UserDefaults.standard.set(imageQueue, forKey: key) // Save updated queue
        
        return nextImage
    }
}

