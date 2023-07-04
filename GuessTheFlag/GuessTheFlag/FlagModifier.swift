//
//  FlagModifier.swift
//  GuessTheFlag
//
//  Created by Anay Sahu on 7/3/23.
//

import Foundation
import SwiftUI

struct FlagModifiers: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(Capsule())
            .shadow(radius: 10)
    }
}

