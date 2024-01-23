//
//  ViewExtension-ButtonModifiers.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 1/21/24.
//

import SwiftUI
import Foundation

extension View {
    func buttonModifier(width: CGFloat, height: CGFloat = 25) -> some View {
        self
            .bold()
            .foregroundColor(.white)
            .frame(width: width, height: height)
            .background(.blue)
            .opacity(0.6)
            .cornerRadius(10)
    }
    
    func warningModifier() -> some View {
        self
            .font(.title3)
            .foregroundColor(.orange)
            .opacity(0.8)
    }
}
