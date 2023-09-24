//
//  SeperatorView.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 9/18/23.
//

import SwiftUI

struct Seperator: View {
    var width: CGFloat
    
    var body: some View {
        Rectangle()
            .frame(width: width, height: 2)
            .foregroundColor(.secondary)
            .padding(.vertical)
    }
}

struct SeperatorView_Previews: PreviewProvider {
    static var previews: some View {
        Seperator(width: 10)
    }
}
