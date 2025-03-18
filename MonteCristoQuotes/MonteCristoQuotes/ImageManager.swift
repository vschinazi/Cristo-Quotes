import Foundation

class ImageManager {
    private static let key = "usedImagesQueue"
    private static var cachedImages: [String] = []

    static func loadImages() {
        if cachedImages.isEmpty {
            cachedImages = (1...50).map { "image\($0)" } // Load images once
        }
    }

    static func getRandomImage() -> String {
        loadImages() // Ensure images are loaded once

        var imageQueue = UserDefaults.standard.array(forKey: key) as? [String] ?? []

        if imageQueue.isEmpty {
            imageQueue = cachedImages.shuffled()
        }

        let nextImage = imageQueue.removeFirst()
        UserDefaults.standard.set(imageQueue, forKey: key)

        return nextImage
    }
}

