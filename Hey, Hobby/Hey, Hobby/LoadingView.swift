//
//  LoadingView.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 12/12/23.
//

import SwiftUI

//If loading the user info takes too long, this view will be displayed

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView("Loading user info...")
                .scaleEffect(5)
                .font(.system(size:6))
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
