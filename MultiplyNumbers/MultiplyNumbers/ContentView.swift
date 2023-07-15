//
//  ContentView.swift
//  MultiplyNumbers
//
//  Created by Anay Sahu on 7/13/23.
//

import SwiftUI

struct ContentView: View {
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isPresented = false
    @State private var answer = ""
    @State private var multiplyTable = 2
    @State private var numOfQuestions = 5
    @State private var question = Int.random(in: 1...10)
    @State private var gameOver = false
    @State private var reset = false
    let options = [3, 5, 7]
    @State private var count = 1
    
    
    
    var body: some View {
        VStack {
            Stepper("Multiplication Table: \(multiplyTable)", value: $multiplyTable, in: 2...12)
            Spacer()
            HStack {
                Text("Select you number of questions")
                Picker("Number of questions", selection: $numOfQuestions) {
                    ForEach(options, id: \.self) { option in
                        Text("\(option)")
                    }
                }
                .onChange(of: numOfQuestions, perform: { newValue in
                    if count > 1 {
                        reset = true
                    }
                })
                .pickerStyle(.segmented)
            }
            
//            HStack {
//                QuestionView(QVmultiplyTable: multiplyTable, randomNum: questions[0])
//            }
            
            HStack(spacing: 10) {
                Text("\(multiplyTable)")
                Text("X")
                Text("\(question)")
                Text("=")
                TextField("?      ", text: $answer)
                    .onSubmit(checkAnswer)
                    
            }
            .font(.title)
            .padding(.leading)
            .padding(.leading)
            
            Text("You are on question \(count)!")
            
            
            Spacer()
            Spacer()
            
            
        }
        .padding(15)
        .alert(alertTitle, isPresented: $isPresented) {
            Button("OK", role: .cancel) {
                if count == numOfQuestions {
                    gameOver.toggle()
                }
            }
        } message: {
            Text(alertMessage)
        }
        .alert("Game Over", isPresented: $gameOver) {
            Button("Restart", role: .cancel) {
                count = 1
            }
        }
        .alert("Are you sure you want to restart?", isPresented: $reset) {
            Button("Reset Game", role: .destructive) {
                question = Int.random(in: 1...10)
                count = 1
            }
            Button("Cancel", role: .cancel) {}
        }
        
    }
    
    func checkAnswer() {
        
            if multiplyTable * question == Int(answer) {
                alertTitle = "Correct!"
                alertMessage = "Your answer is correct"
            } else {
                alertTitle = "Wrong!"
                alertMessage = "\(multiplyTable) X \(question) is equal to \(multiplyTable * question)"
            }
        isPresented.toggle()
            question = Int.random(in: 1...10)
            answer = ""
            count += 1
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct QuestionView: View {
    @State private var answer = ""
    var QVmultiplyTable: Int
    var randomNum: Int
    
    var body: some View {
        HStack(spacing: 10) {
            Text("\(QVmultiplyTable)")
            Text("X")
            Text("\(randomNum)")
            Text("=")
            TextField("?      ", text: $answer)
                
        }
        .font(.title)
        .padding(.leading)
        .padding(.leading)
        
    }
}


