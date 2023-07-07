//
//  ContentView.swift
//  BetterRest
//
//  Created by Anay Sahu on 7/5/23.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUpTime = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var teaAmount = 1
    
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var bedtime: String {
        do {
            let config = MLModelConfiguration()
            let model = try CalculateSleep(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUpTime)
            let hours = (components.hour ?? 0) * 60 * 60
            let minutes = (components.minute ?? 0) * 60
            let prediction = try model.prediction(wake: Double(hours + minutes), estimatedSleep: sleepAmount, coffee: Double(teaAmount))
            
            let sleepTime = wakeUpTime - prediction.actualSleep
            
            return "Your ideal bedtime is..." + sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            return "Sorry, there was a problem calculating your bedtime"
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                   
                    DatePicker("Please enter a time", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                } header: {
                    Text("When do you want to wake up?")
                        
                }
                
                Section {
                    
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                } header: {
                    Text("How much time do you want to sleep for?")
                        
                }
                
                Section {
                    Picker("Number of cups", selection: $teaAmount) {
                        ForEach(0..<21, id: \.self) { number in
                            Text("\(number)")
                        }
                    }
                } header: {
                    Text("Cups of tea")
                }
                
                Section {
                    Text("\(bedtime)")
                        .font(.title3)
                }
            }
            .navigationTitle("BetterRest")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
