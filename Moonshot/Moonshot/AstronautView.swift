//
//  AstronautView.swift
//  Moonshot
//
//  Created by Anay Sahu on 7/21/23.
//

import SwiftUI

struct AstronautView: View {
    var astronaut: Astronuat
    
    var body: some View {
        ScrollView {
            VStack {
                Image(astronaut.id)
                    .resizable()
                    .scaledToFit()
                
                Text(astronaut.description)
                    .padding()
                    .foregroundColor(.white)
            }
        }
        .background(.darkBackround)
        .navigationTitle(astronaut.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AstronautView_Previews: PreviewProvider {
    static var astronaut: [String: Astronuat] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        AstronautView(astronaut: astronaut["aldrin"]!)
    }
}
