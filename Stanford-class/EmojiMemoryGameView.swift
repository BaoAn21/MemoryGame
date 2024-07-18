//
//  ContentView.swift
//  Stanford-class
//
//  Created by Trần Ân on 13/5/24.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    typealias Card = MemoryGame<String>.Card
    
    @ObservedObject var viewModel: EmojiMemoryGame
    
    private let aspectRatio: CGFloat = 2/3    
    var body: some View {
        VStack {
            Text("Memorize!")
                .font(.title)
                .bold()
            cards
            Spacer()
            HStack(spacing: 30) {
                themeButton(text: "Shuffle", image: "water.waves")
                Text("\(viewModel.score)")
                    .animation(nil)
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
    
    
    var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio:aspectRatio) { card in
            ZStack {
                FlyingNumber(number: scoreChange(causedBy: card)).zIndex(1)
                CardView(card)
                    .padding(4)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 1)) {
                            let scoreBeforeChoosing = viewModel.score
                            viewModel.choose(card)
                            let scoreChange = viewModel.score - scoreBeforeChoosing
                            lastScoreChange = (scoreChange, causedByCardID: card.id)
                        }
                    }.foregroundColor(Color.red)
            }
        }
    }
    
    @State private var lastScoreChange = (0, causedByCardID: "")
    
    func scoreChange(causedBy card: Card) -> Int {
        let (amount, id) = lastScoreChange
        return card.id == id ? amount : 0
    }
    
    func themeButton(text: String, image: String) -> some View {
        VStack {
            Button(action: {
                withAnimation {
                    changeTheme(to: text)
                }
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

#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
