//
//  GuessTheFlagView.swift
//  GuessTheFlag
//
//  Created by Anay Sahu on 6/29/23.
//

import SwiftUI



struct GuessTheFlagView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Poland", "Nigeria", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAns = Int.random(in: 0...2)
    @State private var score = 0
    @State private var qCount = 1
    @State private var isGameOver = false
    
    struct FlagModifiers: ViewModifier {
        func body(content: Content) -> some View {
            content
                .clipShape(Capsule())
                .shadow(radius: 10)
        }
    }
    
    var body: some View {
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.15, green: 0.2, blue: 0.65), .white, Color(red: 0.95, green: 0.3, blue: 0.3)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess The Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white )
                VStack(spacing: 30) {
                    VStack {
                        Text("Tap the Flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAns])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagWasTapped(number)
                        } label: {
                            Image(countries[number])
                                .modifier(FlagModifiers())
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(50)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 40))
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
            
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue" ,action: askQuestion)
        } message: {
            Text("Your Score is \(score)")
        }
        .alert("Game Over!", isPresented: $isGameOver) {
            Button("Restart Game") {
                restartGame()
            }
        } message: {
            Text("Your Final Score is \(score)")
        }
        
        
    }
    
    func restartGame() {
        correctAns = Int.random(in: 0...2)
        countries.shuffle()
        qCount = 1
        score = 0
    }
    
    func flagWasTapped(_ number: Int) {
        if number == correctAns {
            scoreTitle = "Correct"
            score += 10
        } else {
            scoreTitle = "Wrong! That is the Flag of \(countries[number])"
            score -= 10
        }
        showingScore = true
        
        
    }
    
    func askQuestion() {
        qCount += 1
        if qCount > 8 {
            isGameOver = true
            print("Game is over")
        } else {
            correctAns = Int.random(in: 0...2)
            countries.shuffle()
        }
        
       
    }
}

struct GuessTheFlagView_Previews: PreviewProvider {
    static var previews: some View {
        GuessTheFlagView()
    }
}
