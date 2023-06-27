//
//  ContentView.swift
//  Time Conversion
//
//  Created by Anay Sahu on 6/20/23.
//

import SwiftUI

struct ContentView: View {
    @State private var units = 0
    @State private var inputUnit = "Seconds"
    @State private var outputUnit = "Minutes"
    var timeUnits = ["Seconds", "Minutes", "Hours", "Days"]
    
    var convertToSec: Int {
        switch inputUnit {
        case "Days":
            return units * 24 * 60 * 60
        case "Hours":
            return units * 60 * 60
        case "Minutes":
            return units * 60
        default:
            return units
        }
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Pick your input unit", selection: $inputUnit) {
                        ForEach(timeUnits, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Picker("Pick your output unit", selection: $outputUnit) {
                        ForEach(timeUnits, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Pick your input and output units")
                }
                
                Section {
                    TextField("Input your amount of \(inputUnit)", value: $units, format: .number)
                } header: {
                    Text("\(inputUnit)")
                    
                }
                
                Section {
                    Text(convertUnits(unit:outputUnit))
                    

                    
//                    if (input == "Seconds" && output == "Minutes") || (input == "Minutes" && output == "Hours") {
//                        Text("\((Double(units) ?? 1) / 60)")
//                    } else if input == "Hours" && output == "Days" {
//                        Text("\((Double(units) ?? 1) / 24)")
//                    } else if input == "Days" && output == "Hours" {
//                        Text("\((Double(units) ?? 1) * 24)")
//                    } else if (input == "Hours" && output == "Minutes") || (input == "Minutes" && output == "Seconds") {
//                        Text("\((Double(units) ?? 1) * 60)")
//                    } else {
//                        Text(units)
//                    }
                } header: {
                    Text(outputUnit)
                }
            }
            .navigationTitle("Time Conversion")
        }
        
    }
    
    func convertUnits(unit: String) -> String{
        switch unit {
        case "Days":
            var days = convertToSec / (24 * 60 * 60)
            var remainingSeconds = convertToSec % (24 * 60 * 60)
            
            
            var hours = remainingSeconds / (60 * 60)
            remainingSeconds = remainingSeconds % (60 * 60)
            
            var min = remainingSeconds / 60
            remainingSeconds = remainingSeconds % 60
            
            //var sec = remainingSeconds
            return "\(days)D:\(hours)H:\(min)M:\(remainingSeconds)S"
        case "Hours":
            var hours = convertToSec / (60 * 60)
            var min = (convertToSec % (60 * 60)) / 60
            var sec = (convertToSec % (60 * 60)) % 60
            return "\(hours)H:\(min)M:\(sec)S"
        case "Minutes":
            var min = convertToSec / 60
            var sec = convertToSec % 60
            return "\(min)M:\(sec)S"
        case "Seconds":
            return "\(convertToSec)"
        default:
            return"\(units)"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
    
