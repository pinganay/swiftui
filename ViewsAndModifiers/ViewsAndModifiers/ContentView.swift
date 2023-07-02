//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Anay Sahu on 7/1/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.purple
            VStack {
                Spacer()
                    .frame(height: 60)
                Text("First Text")
                    .background(.green)
                Spacer()
                HStack(spacing: 20) {
                    VStack {
                        HStack{
                            Spacer()
                            Text("Second Text")
                                .background(.yellow)
                        }
                        Spacer()
                        HStack {
                            Text("Third Text")
                                .background(.red)
                        }
                        
                    }
                    .frame(width: 250, height: 150)
                    .background(.green)
                    
                    //Spacer()
                    
                    Text("Fourth Text")
                        .background(.green)
                    
                }
                .padding()
                Spacer()
                    .frame(height: 320)
                
                HStack(spacing: 30) {
                    Text("Fifth Text")
                        .background(.red)
                        .padding(10)
                    Text("Sixth Text")
                        .background(.yellow)
                        .padding(10)
                }
                .frame(width: 150, height: 100)
                .background(.green)
                Spacer()
                    .frame(height: 50)
                
            }
            
        }
        .ignoresSafeArea()

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
