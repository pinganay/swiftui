//
//  LoadingURLView.swift
//  CupcakeCorner
//
//  Created by Anay Sahu on 7/26/23.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct LoadingURLView: View {
    @State private var results = [Result]()
    
    var body: some View {
        List(results, id: \.trackId) { item in
            VStack(alignment: .leading) {
                Text(item.trackName)
                    .font(.headline)
                Text(item.collectionName)
            }
        }
        .task {
            await loadData()
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let response = try? JSONDecoder().decode(Response.self, from: data) else {
                print("Failed to decode")
                return
            }
            results = response.results
        } catch {
            print("Error")
        }
    }
       
}

struct LoadingURLView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingURLView()
    }
}
