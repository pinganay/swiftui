//
//  confirmationDialogView.swift
//  Instafilter
//
//  Created by Anay Sahu on 8/29/23.
//

import SwiftUI

struct confirmationDialogView: View {
    @State private var backgroundColor = Color.white
    @State private var showingConfirmation = false
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .frame(width: 300, height: 300)
            .background(backgroundColor)
            .onTapGesture {
                showingConfirmation = true
            }
            .confirmationDialog("Set Color", isPresented: $showingConfirmation) {
                Button("Red") { backgroundColor = .red }
                Button("Blue") { backgroundColor = .blue }
                Button("Green") { backgroundColor = .green }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Set your prefered color")
            }
    }
}

struct confirmationDialogView_Previews: PreviewProvider {
    static var previews: some View {
        confirmationDialogView()
    }
}
