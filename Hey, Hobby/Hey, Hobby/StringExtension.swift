//
//  StringExtension.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 12/19/23.
//

import Foundation

extension String {
    var containsWhitespace: Bool {
        return rangeOfCharacter(from: .whitespacesAndNewlines) != nil
    }
    
    var isInt: Bool {
        Int(self) != nil
    }
    
    var isPhoneNumberLengthValid: Bool {
        if self.count >= 8 && self.count <= 13 {
            return true
        }
        
        return false
    }
    
    var isNotEmpty: Bool {
        !self.isEmpty
    }
}
