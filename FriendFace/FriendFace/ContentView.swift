//
//  ContentView.swift
//  FriendFace
//
//  Created by Anay Sahu on 8/23/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var users: FetchedResults<CachedUserData>
    
    var body: some View {
        NavigationView {
            List(users, id: \.id) { user in
                NavigationLink {
                    UserDataView(user: user)
                } label: {
                    VStack(alignment: .leading) {
                        Text(user.wrappedName)
                        Text(user.isActive ? "Active" : "Inactive")
                            .font(.caption)
                            .foregroundColor(user.isActive ? .green : .red)
                    }
                }
            }
            .task {
                await loadData()
            }
            .navigationTitle("Friend Face")
        }
        
    }
    
    func loadData() async {
        print("Loading Data")
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let users = try decoder.decode([UserData].self, from: data)
            
            await MainActor.run {
                updateCache(with: users)
            }
            
        } catch {
            print("Invalid Data")
        }
    }
    
    func updateCache(with downloadedUsers: [UserData]) {
        for user in downloadedUsers {
            let cachedUser = CachedUserData(context: moc)
            
            cachedUser.registered = user.registered
            cachedUser.name = user.name
            cachedUser.id = user.id
            cachedUser.age = Int16(user.age)
            cachedUser.company = user.company
            cachedUser.address = user.address
            cachedUser.about = user.about
            cachedUser.tags = user.tags.joined(separator: ",")
            cachedUser.isActive = user.isActive
            
            for friend in user.friends {
                let cachedFriend = CachedFriend(context: moc)
                
                cachedFriend.id = friend.id
                cachedFriend.name = friend.name
                
                //line below crashes app
                //cachedUser.addToFriends(cachedFriend)
            }
        }
        
        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
