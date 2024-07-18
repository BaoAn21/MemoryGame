//
//  CardView.swift
//  Stanford-class
//
//  Created by Trần Ân on 21/5/24.
//

import SwiftUI

struct CardView: View {
    
    let card: MemoryGame<String>.Card
    
    init(_ card: MemoryGame<String>.Card) {
        self.card = card
    }
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Pie(endAngle: .degrees(card.bonusPercentRemaining * 360))
                .opacity(0.5)
                .overlay (
                    Text(card.content)
                        .font(.system(size: 200))
                        .minimumScaleFactor(0.01)
                        .multilineTextAlignment(.center)
                        .aspectRatio(1,contentMode: .fit)
                        .padding(5)
                        .rotationEffect(.degrees(card.isMatched ? 360 : 0))
                        .animation(Animation.spin(duration: 1), value: card.isMatched)
                ).padding(5)
                .modifier(Cardify(isFaceUp: card.isFaceup))
            .opacity(card.isMatched && !card.isFaceup ? 0 : 1)
        }
        
    }
}

extension Animation {
    static func spin(duration: TimeInterval) -> Animation {
        return Animation.linear(duration: duration).repeatForever(autoreverses: false)
    }
}

#Preview {
    CardView(MemoryGame<String>.Card(id: "tasta", isFaceup: false, content: "asdfsadfasfasfafsdfasf"))
}
