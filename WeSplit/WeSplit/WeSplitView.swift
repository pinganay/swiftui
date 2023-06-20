//
//  WeSplitView.swift
//  WeSplit
//
//  Created by Anay Sahu on 6/18/23.
//

import SwiftUI

struct WeSplitView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeopleSelected = 2
    @State private var tipPercentage = 20
    @FocusState private var isFocused: Bool
    let localCurrency: FloatingPointFormatStyle<Double>.Currency = .currency(code: Locale.current.currency?.identifier ?? "USD")
    
    private var tipAmount: Double {
        checkAmount * Double(tipPercentage) / 100
    }
    
    private var totalCheckAmount: Double {
        checkAmount + tipAmount
    }
    
    private var splitAmount: Double {
        (checkAmount + tipAmount) / Double(numberOfPeopleSelected)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Enter Check Amount here", value: $checkAmount, format: localCurrency)
                        .keyboardType(.decimalPad)
                        .focused($isFocused)
                    
                    Picker("Select Number of People", selection: $numberOfPeopleSelected) {
                        ForEach(1..<100, id: \.self) { num in
                            Text("\(num)")
                        }
                    }
                    .pickerStyle(.navigationLink)
                } header: {
                    Text("Check Amount")
                }
                
                Section {
                    Picker("Select Tip percentage", selection: $tipPercentage) {
                        ForEach(0..<101, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.navigationLink)
                } header: {
                    Text("Tip Percentage")
                }
                
                Section {
                    Text(totalCheckAmount, format: localCurrency)
                } header: {
                    Text("Total Check Amount")
                }
                
                Section {
                    Text(splitAmount, format: localCurrency)
                } header: {
                    Text("Split Amount")
                }
                
                    
                
//                Text("Split Amount: \(splitAmount)", format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
            }
            .navigationTitle("WeSplit")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer(minLength: 10)
                    
                    Button("Done") {
                        isFocused = false
                    }
                }
            }
        }
    }
}

struct WeSplitView_Previews: PreviewProvider {
    static var previews: some View {
        WeSplitView()
    }
}

