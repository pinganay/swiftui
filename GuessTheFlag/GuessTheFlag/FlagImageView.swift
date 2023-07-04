//
//  FlagImageView.swift
//  GuessTheFlag
//
//  Created by Anay Sahu on 7/3/23.
//

import SwiftUI

struct FlagImageView: View {
    var countryName: String
    
    var body: some View {
        Image(countryName)
            .modifier(FlagModifiers())
    }
}

struct FlagImageView_Previews: PreviewProvider {
    static var previews: some View {
        FlagImageView(countryName: "France")
    }
}
