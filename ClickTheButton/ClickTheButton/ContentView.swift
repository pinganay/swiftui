//
//  ContentView.swift
//  ClickTheButton
//
//  Created by Anay Sahu on 8/1/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            NavigationLink {
                SecondButtonView()
            } label: {
                Text("Click Me")
                    .frame(width: 200, height: 200)
                    .background(.red)
                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
                    .foregroundColor(.white)
            }
            .navigationTitle("Click The Button")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
