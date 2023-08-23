//
//  AddBookView.swift
//  BookWorm
//
//  Created by Anay Sahu on 8/3/23.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var author = ""
    @State private var genre = "Fantasy"
    @State private var review = ""
    @State private var rating = 3
    @State private var date = Date.now
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    var isValidData: Bool {
        if title.isEmpty || author.isEmpty {
            return true
        }
        return false
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Who is the author?", text: $author)
                    
                    Picker("What is the genre?", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section {
                    TextEditor(text: $review)
                    
                    RatingView(rating: $rating)
                } header: {
                    Text("Write a review!")
                }
                
                Section {
                    Button("Save") {
                        let book = Book(context: moc)
                        
                        book.title = title
                        book.genre = genre
                        book.author = author
                        book.review = review
                        book.rating = Int16(rating)
                        book.date = Date.now   
                        book.id = UUID()
                        
                        try? moc.save()
                        
                        dismiss()
                    }
                    .disabled(isValidData)
                }
            }
            .navigationTitle("Add Book")
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
