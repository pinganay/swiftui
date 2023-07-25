//
//  Activity.swift
//  HabitTracker
//
//  Created by Anay Sahu on 7/23/23.
//

import Foundation

struct Activity: Identifiable, Codable, Equatable {
    let id = UUID()
    let name: String
    let description: String
    //let completionCnt = 0
}
