//
//  ContentView.swift
//  HabitTracker
//
//  Created by Anay Sahu on 7/23/23.
//

import SwiftUI

class Activities: ObservableObject {
    @Published var activityList = [Activity]()
}

struct ContentView: View {
    //@State private var activities = [Activity]()
    @State private var showAddScreen = false
    @StateObject var activities = Activities()
//    @State private var encodedData = UserDefaults.standard.data(forKey: "Activities") ?? Data()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(activities.activityList) { activity in
                    NavigationLink {
                        ActivityDetailsView(activities: activities, activity: activity)
                    } label: {
                        Text(activity.name)
                    }
                }
                .onDelete(perform: removeObject)
            }
            .navigationTitle("Habit Tracker")
            .onAppear {
                if let savedData = UserDefaults.standard.data(forKey: "Activities") {
                    if let savedActivities = try? JSONDecoder().decode([Activity].self, from: savedData) {
                        dump(savedActivities)
                        activities.activityList.append(contentsOf: savedActivities)
                    }
                }
            }
            .toolbar {
                
                
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddScreen = true
                    } label: {
                        Image(systemName: "plus")
                }
                }
            }
            .sheet(isPresented: $showAddScreen) {
                addActivityView(activities: activities)
            }
        }
    }
    
    func removeObject(at offset: IndexSet) {
        activities.activityList.remove(atOffsets: offset)
        if let data = try? JSONEncoder().encode(activities.activityList) {
            UserDefaults.standard.set(data, forKey: "Activities")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
