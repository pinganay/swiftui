//
//  BookWormView.swift
//  BookWorm
//
//  Created by Anay Sahu on 7/30/23.
//

import SwiftUI

struct BookWormView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.rating, order: .reverse), SortDescriptor(\.title)]) var books: FetchedResults<Book>
    
    @State private var showingAddBookView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(books) { book in
                    NavigationLink {
                        DetailView(book: book)
                    } label: {
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)
                            VStack {
                                Text(book.title ?? "Unknown")
                                    .font(.headline)
                                Text(book.author ?? "Unknown")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationTitle("Bookworm")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddBookView.toggle()
                    } label: {
                        Label("Add Book", systemImage: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddBookView) {
                AddBookView()
        }
        }
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            moc.delete(book)
        }
        
        try? moc.save()
    }
}

struct BookWormView_Previews: PreviewProvider {
    static var previews: some View {
        BookWormView()
    }
}
