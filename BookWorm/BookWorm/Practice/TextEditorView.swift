//
//  TextEditorView.swift
//  BookWorm
//
//  Created by Anay Sahu on 7/30/23.
//

import SwiftUI

struct TextEditorView: View {
    @AppStorage("notes") var notes = ""
    
    var body: some View {
        NavigationView {
            TextEditor(text: $notes)
                .navigationTitle("Notes")
        }
    }
}

struct TextEditorView_Previews: PreviewProvider {
    static var previews: some View {
        TextEditorView()
    }
}
