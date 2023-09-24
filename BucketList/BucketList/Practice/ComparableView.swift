//
//  ComparableView.swift
//  BucketList
//
//  Created by Anay Sahu on 9/1/23.
//

import SwiftUI


struct User: Identifiable, Comparable {
    let id = UUID()
    let fName: String
    let lName: String
    
    static func <(lhs: User, rhs: User) -> Bool {
        return lhs.lName < rhs.lName
    }
}

struct ComparableView: View {
    let users = [
        User(fName: "Anay", lName: "Sahu"),
        User(fName: "Archi", lName: "Lahu"),
        User(fName: "Sarmila", lName: "Fahu"),
        User(fName: "Rabi", lName: "Kahu")
    ].sorted()
    
    var body: some View {
        List(users) { user in
            Text("\(user.fName) \(user.lName)")
        }
    }
}

struct ComparableView_Previews: PreviewProvider {
    static var previews: some View {
        ComparableView()
    }
}
