//
//  ColorExtension-BackroundColor.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 1/19/24.
//

import Foundation
import SwiftUI

//extension Color {
//    static let themeColor = Color("AppIconColor")
//}

extension ShapeStyle where Self == Color {
    public static var themeColor: Color {
        Color("AppIconColor")
    }
}
