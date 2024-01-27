//
//  FontExtension-CustomFont.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 1/21/24.
//

import SwiftUI
import Foundation

extension Font {
    static var indieFlower: Font {
        self.custom("IndieFlower", size: 34)
    }
    
    static var rubikScribble: Font{
        self.custom("RubikScribble-Regular", size: 34)
    }
    
    static var rubikDoodleShadow: Font {
        self.custom("RubikDoodleShadow-Regular", size: 34)
    }
    
    static var courgette: Font {
        self.custom("Courgette-Regular", size: 34)
    }
    
    static var pacifico: Font {
        self.custom("Pacifico-Regular", size: 34)
    }
    
    static var titleScript: Font {
        self.custom("Bukhari-Script", size: 34)
    }
    
    static var titleScriptSmall: Font {
        self.custom("Bukhari-Script", size: 25)
    }
}
