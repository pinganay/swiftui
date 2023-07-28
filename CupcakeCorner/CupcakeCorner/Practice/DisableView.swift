//
//  DisabledView.swift
//  CupcakeCorner
//
//  Created by Anay Sahu on 7/26/23.
//

import SwiftUI

struct DisableView: View {
    @State private var name = ""
    @State private var age = ""
    @State private var showingSheet = false
    var isSaveButtonDisabled: Bool {
        if name == "" || age == "" {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        VStack {
            Form {
                TextField("Name", text: $name)
                TextField("Age", text: $age)
            }
            
            Button {
                showingSheet = true
            } label: {
                Text("Save")
            }
            .disabled(isSaveButtonDisabled)
        }
        .sheet(isPresented: $showingSheet) {
            Text("Saved")
        }
    }
//    func isDisabled() {
//        if name == "" || age == "" {
//            isSaveButtonDisabled = false
//        } else {
//            isSaveButtonDisabled = true
//        }
//    }
}

struct DisabledView_Previews: PreviewProvider {
    static var previews: some View {
        DisableView()
    }
}
