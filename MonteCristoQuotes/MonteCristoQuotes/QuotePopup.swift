import SwiftUI

struct QuotePopup: View {
    var body: some View {
        ZStack {
            Image("parchment")
                .resizable()
                .aspectRatio(contentMode: .fill) // Ensures better scaling
                .frame(width: 450, height: 200)
                .clipped()
                .opacity(0.9)
                .onTapGesture {
                    QuotePopupManager.closePopup()
                }

            VStack {
                HStack {
                    Image(ImageManager.getRandomImage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: .gray, radius: 6, x: 2, y: 2)
                        .padding(.top, 10)

                    VStack(alignment: .leading) {
                        Text(QuoteManager.getRandomQuote())
                            .font(.custom("Big Caslon", size: 20))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .lineLimit(4)
                            .truncationMode(.tail)
                            .frame(maxWidth: 250, maxHeight: 100, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 5)
                            .padding(.bottom, 5)
                            .background(Color.clear)
                    }
                    .frame(minHeight: 150, alignment: .center)
                    .padding(.leading, 10)
                }

                Text("Alexandre Dumas")
                    .font(.custom("SignPainter", size: 18))
                    .italic()
                    .foregroundColor(.black.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 5)
                    .padding(.bottom, 2)
            }
            .padding(15)
        }
        .frame(width: 450, height: 200)
        .cornerRadius(15)
        .shadow(radius: 1)
    }
}

