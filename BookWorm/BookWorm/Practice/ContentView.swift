//
//  ContentView.swift
//  BookWorm
//
//  Created by Anay Sahu on 7/30/23.
//

import SwiftUI

struct ButtonView: View {
    var title: String
    @Binding var isOn: Bool
    
    var body: some View {
        Button(title) {
            isOn.toggle()
        }
        .background(isOn ? .red : .gray)
        .foregroundColor(.black)
        .clipShape(Capsule())
    }
}

struct ContentView: View {
    @State private var remember = false
    
    var body: some View {
        VStack {
            ButtonView(title: "Remember", isOn: $remember)
            Text(remember ? "on" : "off")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
