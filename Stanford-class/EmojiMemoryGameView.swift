//
//  ContentView.swift
//  Stanford-class
//
//  Created by Trần Ân on 13/5/24.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    private let aspectRatio: CGFloat = 1 
        
    var body: some View {
        VStack {
            Text("Memorize!")
                .font(.title)
                .bold()
            cards
                .animation(.default, value: viewModel.cards)
            
            Spacer()
            HStack(spacing: 30) {
                themeButton(text: "Shuffle", image: "water.waves")
                themeButton(text: "NewGame", image: "water.waves")
            }
        }.padding()
    }
    
    
    
    // -- VIEW AND FUNCTION ---
    func changeTheme(to text: String) {
        switch text {
        case "NewGame":
            viewModel.newGame()
        case "Shuffle":
            viewModel.shuffle()
        default:
            // just place here
            viewModel.shuffle()
        }
    }
    
    @ViewBuilder
    var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio:aspectRatio) { card in
            CardView(card)
                .padding(4)
                .onTapGesture {
                    viewModel.choose(card)
            }
        }.foregroundColor(Color.orange)
    }
    
    func themeButton(text: String, image: String) -> some View {
        VStack {
            Button(action: {
                changeTheme(to: text)
            }) {
                VStack {
                    Image(systemName: image)
                        .imageScale(.large)
                        .font(.largeTitle)
                    Text(text)
                        .font(.callout)
                }
                
            }
        }
        
    }
}


// -- BIGVIEW
struct CardView: View {
    
    let card: MemoryGame<String>.Card
    
    init(_ card: MemoryGame<String>.Card) {
        self.card = card
    }
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base
                    .fill(Color.white)
                    .strokeBorder(lineWidth: 2)
                Text(card.content)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.01)
                    .aspectRatio(1,contentMode: .fit)
            }
            .opacity(card.isFaceup ? 1 : 0)
            base.fill()
                .opacity(card.isFaceup ? 0 : 1)
        }.opacity(card.isMatched && !card.isFaceup ? 0 : 1)
        
    }
}

#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
