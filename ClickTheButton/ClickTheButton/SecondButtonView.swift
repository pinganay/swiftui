//
//  SecondButtonView.swift
//  ClickTheButton
//
//  Created by Anay Sahu on 8/1/23.
//

import SwiftUI

struct SecondButtonView: View {
    var body: some View {
        NavigationView {
            NavigationLink {
                ThirdButtonView()
            } label: {
                Text("")
            }
        }
    }
}

struct SecondButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SecondButtonView()
    }
}
