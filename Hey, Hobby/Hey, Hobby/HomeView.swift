//
//  HomeView.swift
//  Hey, Hobby
//
//  Created by Anay Sahu on 9/17/23.
//

import SwiftUI

struct HomeView: View {
    let user = DBUser.sampleUser
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    HStack {
                        VStack(alignment: .center) {
                            Text("Joined Communities")
                                .font(.title2)
                            Seperator(width: 100)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .center) {
                            Text("Communities that you made")
                                .font(.title2)
                            Seperator(width: 100)
                        }
                    }
                    .padding()
                    .padding(.bottom, 150)
                }
                .navigationTitle("Hey, Hobby")
                .toolbar {
                    NavigationLink {
                        //UserProfile(isLoggedIn: <#Binding<Bool>#>)
                    } label: {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
