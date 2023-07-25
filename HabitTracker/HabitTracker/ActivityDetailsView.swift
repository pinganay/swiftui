//
//  ActivityDetailsView.swift
//  HabitTracker
//
//  Created by Anay Sahu on 7/24/23.
//

import SwiftUI

struct ActivityDetailsView: View {
    @ObservedObject var activities: Activities
    var activity: Activity
    
    var body: some View {
        VStack{
            Text(activity.name)
            Text(activity.description)
        }
        
        
    }
}

struct ActivityDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetailsView(activities: Activities(), activity: Activity(name: "AAA", description: "BBB"))
    }
}
