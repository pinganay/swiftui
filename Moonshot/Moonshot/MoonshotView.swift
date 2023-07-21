//
//  MoonshotView.swift
//  Moonshot
//
//  Created by Anay Sahu on 7/18/23.
//

import SwiftUI



struct MoonshotView: View {
    @State private var gridView = true
    
    let astronuats: [String: Astronuat] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                if gridView {
                    GridLayoutView(missions: missions, astronuats: astronuats)
                } else {
                    ListLayoutView(missions: missions, astronuats: astronuats)
                }
            }
            .navigationTitle("Moonshot")
            .background(.darkBackround)
            .preferredColorScheme(.dark)
            .toolbar {
                Button(gridView ? "Show List View" : "Show Grid View") {
                    withAnimation {
                        gridView.toggle()
                    }
                }
            }
        }
    }
}

struct MoonshotView_Previews: PreviewProvider {
    static var previews: some View {
        MoonshotView()
    }
}
