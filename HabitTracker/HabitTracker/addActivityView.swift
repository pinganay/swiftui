//
//  addActivityView.swift
//  HabitTracker
//
//  Created by Anay Sahu on 7/23/23.
//

import SwiftUI

struct addActivityView: View {
    @State private var activityName = ""
    @State private var activityDescription = ""
    @ObservedObject var activities: Activities
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Name:")
                    TextField("Name", text: $activityName)
                }
                
                HStack {
                    Text("Description:")
                    TextField("Description", text: $activityDescription)
                }
                
                Spacer()
                Button("Save") {
                    let activity = Activity(name: activityName, description: activityDescription)
                    activities.activityList.append(activity)
                    
                    if let data = try? JSONEncoder().encode(activities.activityList) {
                        UserDefaults.standard.set(data, forKey: "Activities")
                    }
                    
                    dismiss()
                }
                
            }
            .navigationTitle("Add Activity")
        }
    }
}

struct addActivityView_Previews: PreviewProvider {
    static var previews: some View {
        addActivityView(activities: Activities())
    }
}
