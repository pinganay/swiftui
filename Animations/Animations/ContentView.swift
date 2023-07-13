//
//  ContentView.swift
//  Animations
//
//  Created by Anay Sahu on 7/12/23.
//

import SwiftUI

struct ContentView: View {
    @State private var dragAmount = CGSize.zero
    @State private var enabled = false
    let string = Array("Hello, World!")
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<string.count) { num in
                Text(String(string[num]))
                    .padding(5)
                    .font(.title)
                    .background(enabled ? .blue : .red)
                    .offset(dragAmount)
                    .animation(.default.delay(Double(num) / 30), value: dragAmount)
            }
        }
        .gesture (
            DragGesture()
                .onChanged{dragAmount = $0.translation}
                .onEnded{ _ in
                    dragAmount = .zero
                    enabled.toggle()
                }
        )
        
//        VStack {
//            Spacer()
//
//            Button("Tap Me!") {
//                size1 += 0.5
//            }
//            .padding(50)
//            .background(.red)
//            .foregroundColor(.white)
//            .clipShape(Circle())
//            .overlay(
//                Circle()
//                    .stroke(.red)
//                    .scaleEffect(size1)
//                    .opacity(2 - size1)
//                    .animation(
//                        .easeInOut(duration: 1)
//                        .repeatForever(autoreverses: false),
//                        value: size1)
//            )
//            .onAppear {
//                size1 = 2
//            }
//            Spacer()
//            Button("Tap Me!") {
//                withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)) {
//                    size2 += 360
//                }
//            }
//            .padding(50)
//            .background(.red)
//            .foregroundColor(.white)
//            .clipShape(Circle())
//            .rotation3DEffect(.degrees(size2), axis: (x: 1, y: 1, z: 1))
//
//            Spacer()
//        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
