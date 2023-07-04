//
//  ContentView.swift
//  Rock, Paper, Scissors
//
//  Created by Anay Sahu on 7/3/23.
//

import SwiftUI


struct ContentView: View {
    var choices = ["🪨", "📃", "✂️"]
    @State private var computerChoice = Int.random(in: 0...2)
    @State private var shouldWin = Bool.random()
    @State private var score = 0
    
    var body: some View {
        ZStack {
            
            LinearGradient(colors: [.black,.gray,.white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("The Computer Has Played...")
                Text(choices[computerChoice])
                    .font(.system(size: 200))
                Spacer()
                Text(shouldWin ? "Which one Wins?" : "Which one Loses?")
                HStack {
                    ForEach(0..<3) { number in
                        Button {
                            play(choiceIdx: number)
                        } label: {
                            Text(choices[number])
                        }
                        .font(.system(size: 75))
                    }
                }
                Spacer()
                Text("Score: \(score)")
                    .font(.largeTitle)
                Spacer()
            }
            .background(.ultraThinMaterial)
        }
    }
    
    func play(choiceIdx: Int) {
        let winningMoves = [1, 2, 0]
        let didWin: Bool
        
        if shouldWin {
            didWin = choiceIdx == winningMoves[computerChoice]
        } else {
            didWin = winningMoves[choiceIdx] == computerChoice
        }
        
        if didWin {
            score += 1
        } else {
            score -= 1
        }
        
        computerChoice = Int.random(in: 0...2)
        shouldWin.toggle()
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
