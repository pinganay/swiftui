//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Anay Sahu on 6/27/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Color(red: 100, green: 0, blue: 0)
                Color.blue
               
            }
            Button("Click Me", role: .destructive) {}
                .buttonStyle(.borderedProminent)
                .frame(width:  0, height: 200)


        }
        .ignoresSafeArea()
        
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
