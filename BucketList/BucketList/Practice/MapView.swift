//
//  MapView.swift
//  BucketList
//
//  Created by Anay Sahu on 9/2/23.
//

import MapKit
import SwiftUI

//struct Location: Identifiable {
//    let id = UUID()
//    let name: String
//    let coordinate: CLLocationCoordinate2D
//}
//
//struct MapView: View {
//    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7790262, longitude: -122.419906), span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
//    let locations = [
//        Location(name: "Golden Gate Bridge", coordinate: CLLocationCoordinate2D(latitude: 37.8199067, longitude: -122.47858)),
//        Location(name: "Palace of Fine Arts", coordinate: CLLocationCoordinate2D(latitude: 37.3633278, longitude: -121.9293386))
//    ]
//    
//    var body: some View {
//        NavigationView {
//            Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
//                //MapMarker(coordinate: location.coordinate)
//                MapAnnotation(coordinate: location.coordinate) {
//                    NavigationLink {
//                        Text(location.name)
//                    } label: {
//                        Circle()
//                            .fill(.red)
//                    }
//                }
//            }
//            .ignoresSafeArea()
//        }
//    }
//}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
