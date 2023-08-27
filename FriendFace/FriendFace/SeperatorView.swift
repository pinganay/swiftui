//
//  SeparatorView.swift
//  FriendFace
//
//  Created by Anay Sahu on 8/23/23.
//

import SwiftUI

struct SeperatorView: View {
    var body: some View {
        Rectangle()
            .frame(height: 2)
            .foregroundColor(.gray)
            .padding()
    }
}

struct SeparatorView_Previews: PreviewProvider {
    static var previews: some View {
        SeperatorView()
    }
}
