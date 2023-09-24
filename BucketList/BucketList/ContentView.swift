//
//  ContentView.swift
//  BucketList
//
//  Created by Anay Sahu on 9/1/23.
//

import MapKit
import SwiftUI

enum LoadingStates {
    case loading, loaded, failed
}

struct ContentView: View {
    
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    VStack {
                        Image(systemName: "star.circle")
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 44, height: 44)
                            .background(.white)
                            .clipShape(Circle())
                        
                        Text(location.name)
                    }
                    .onTapGesture {
                        viewModel.selectedLocation = location
                    }
                }
            }
            .ignoresSafeArea()
            
            Circle()
                .fill(.blue)
                .opacity(0.35)
                .frame(width: 32, height: 32)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        viewModel.addLocation()
//                        let lat = viewModel.mapRegion.center.latitude
//                        let long = viewModel.mapRegion.center.longitude
//                        let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: lat, longitide: long)
//                        viewModel.locations.append(newLocation)
                    } label: {
                        Image(systemName: "plus")
                    }
                    .padding()
                    .background(.black.opacity(0.7))
                    .foregroundColor(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding(.trailing)
                }
            }
        }
        .sheet(item: $viewModel.selectedLocation) { place in
            EditView(location: place) { newLocation in
//                if let index = viewModel.locations.firstIndex(of: place) {
//                    viewModel.locations[index] = newLocation
//                }
                viewModel.update(location: newLocation)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
