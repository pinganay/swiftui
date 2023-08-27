//
//  UserView.swift
//  FriendFace
//
//  Created by Anay Sahu on 8/23/23.
//

import SwiftUI

struct UserDataView: View {
    var user: CachedUserData
    
    var body: some View {
        VStack() {
            ScrollView {
                VStack(alignment: .leading) {
                    Text(user.wrappedName)
                        .font(.title)
                    
                    Text("Age: \(user.age)")
                        .font(.subheadline)
                    
                    Text("Email: \(user.wrappedEmail)")
                        .font(.subheadline)
                    
                    Text("Company: \(user.wrappedCompany)")
                        .font(.subheadline)
                }
                    
                SeperatorView()
                
                VStack {
                    Text("About")
                        .font(.title)
                    Text(user.wrappedAbout)
                        .padding()
                }
                SeperatorView()
                
                VStack(alignment: .leading) {
                    Text("Tags:")
                        .font(.title)
                    VStack {
                        ForEach(user.wrappedTags.components(separatedBy: ","), id: \.self) { tag in
                            Text(tag)
                        }
                    }
                }
                
                SeperatorView()
                
                VStack(alignment: .leading) {
                    Text("Friends:")
                        .font(.title)
                    ForEach(user.friendsArray, id: \.id) { friend in
                        Text(friend.wrappedName)
                    }
                }
                
                SeperatorView()
                
                Text("Address: \(user.wrappedAddress)")
            }
        }
    }
}
