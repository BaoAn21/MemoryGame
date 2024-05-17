//
//  ContentView.swift
//  Stanford-class
//
//  Created by Trần Ân on 13/5/24.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
        
    var body: some View {
        VStack {
            Text("Memorize!")
                .font(.title)
                .bold()
            ScrollView {
                cards
                    .animation(.default, value: viewModel.cards)
            }
            Spacer()
            HStack(spacing: 30) {
                themeButton(text: "Haloween", image: "person.fill")
                themeButton(text: "Vehicles", image: "car.fill")
                themeButton(text: "Sea", image: "water.waves")
                themeButton(text: "Shuffle", image: "water.waves")
            }
        }.padding()
    }
    
    
    
    // -- VIEW AND FUNCTION ---
    func changeTheme(to text: String) {
        switch text {
        case "Shuffle":
            viewModel.shuffle()
        default:
            // just place here
            viewModel.shuffle()
        }
    }
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 0)], spacing: 0)  {
            ForEach(viewModel.cards) { card in
                VStack {
                    CardView(card)
                        .aspectRatio(2/3, contentMode: .fit)
                        .padding(4)
                        .onTapGesture {
                            viewModel.choose(card)
                        }
                    Text(card.id)
                }
               
            }
        }
        .foregroundColor(Color.orange)
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
        }.opacity(card.isMatched ? 0 : 1)
        
    }
}

#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
