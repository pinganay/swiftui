//
//  LoadImageView.swift
//  CupcakeCorner
//
//  Created by Anay Sahu on 7/26/23.
//

import SwiftUI

struct LoadImageView: View {
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Color.red
            }
            .frame(width: 200, height: 200)
            
            AsyncImage(url: URL(string: "https://hws.dev/img/bad.png")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                } else if phase.error != nil {
                    Text("Error: Failed to loading the image.")
                } else {
                    ProgressView()
                }
            }
            .frame(width: 200, height: 200)

        }
    }
}

struct LoadImageView_Previews: PreviewProvider {
    static var previews: some View {
        LoadImageView()
    }
}
