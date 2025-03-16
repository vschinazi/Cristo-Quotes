import SwiftUI

struct QuoteView: View {
    @State private var randomQuote: String = QuoteManager.getRandomQuote()
    @State private var randomImage: String = ImageManager.getRandomImage()
    
    var body: some View {
        ZStack {
            Image("parchment")  // Ensure this image exists in Assets.xcassets
                .resizable()
                .scaledToFill()
                .frame(width: 450, height: 200)
                .clipped()
                .opacity(0.9)
            
            VStack {
                HStack {
                    Image(randomImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: .gray, radius: 6, x: 2, y: 2)
                    
                    Text(randomQuote)
                        .font(.custom("Big Caslon", size: 20))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 15)
                }
                
                Text("Alexandre Dumas")
                    .font(.custom("SignPainter", size: 18))
                    .italic()
                    .foregroundColor(.black.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 5)
                    .padding(.bottom, 2)
            }
            .padding(.horizontal, 12)
            .padding(10)
        }
        .frame(width: 450, height: 200)
        .cornerRadius(15)
        .shadow(radius: 10)
    }
}

#Preview {
    QuoteView()
}

