//
//  watchStateView.swift
//  Instafilter
//
//  Created by Anay Sahu on 8/29/23.
//

import SwiftUI

struct watchStateView: View {
    @State private var blurAmount = 0.0
    
    var body: some View {
        VStack {
            Text("Hello, world!")
                .blur(radius: blurAmount)
            
            Slider(value: $blurAmount, in: 0...20)
                .onChange(of: blurAmount) { newValue in
                    print("Blur amount: \(newValue)")
                }
            
            Button("Random Blur") {
                blurAmount = Double.random(in: 0...20)
            }
        }
        .padding()
    }
}

struct watchStateView_Previews: PreviewProvider {
    static var previews: some View {
        watchStateView()
    }
}
