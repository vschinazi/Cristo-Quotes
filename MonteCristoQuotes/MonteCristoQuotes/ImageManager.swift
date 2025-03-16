import Foundation

class ImageManager {
    private static var lastImage: String?
    
    static func getRandomImage() -> String {
        let imageNames = (1...50).map { "image\($0)" } // Assumes image1, image2, ..., image50 exist in Assets.xcassets
        
        guard !imageNames.isEmpty else { return "defaultImage" } // Fallback image
        
        var newImage: String
        repeat {
            newImage = imageNames.randomElement() ?? "defaultImage"
        } while newImage == lastImage  // Prevents repeating the same image
        
        lastImage = newImage
        return newImage
    }
}

