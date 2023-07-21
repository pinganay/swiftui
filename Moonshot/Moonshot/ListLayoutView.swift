//
//  ListLayoutView.swift
//  Moonshot
//
//  Created by Anay Sahu on 7/21/23.
//

import SwiftUI

struct ListLayoutView: View {
    
    let missions: [Mission]
    let astronuats: [String: Astronuat]
    
    var body: some View {
        LazyVStack {
            ForEach(missions) { mission in
                NavigationLink {
                    MissionView(mission: mission, astronauts: astronuats)
                } label: {
                    VStack {
                        Image(mission.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .padding()
                        VStack {
                            Text(mission.displayName)
                                .font(.headline)
                                .foregroundColor(.white)
                            Text(mission.formattedLaunchDate)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(.lightBackround)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.lightBackround)
                    )
                }
            }
        }
        .padding([.horizontal, .bottom])
    }
}

struct ListLayoutView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [String: Astronuat] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        ListLayoutView(missions: missions, astronuats: astronauts)
    }
}
