//
//  DetailView.swift
//  BookWorm
//
//  Created by Anay Sahu on 8/7/23.
//

import CoreData
import SwiftUI


struct DetailView: View {
    let book: Book
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    let dateFormatter = DateFormatter()
    
    var body: some View {
        ScrollView {
            Text(dateFormatter.string(from: book.date ?? Date.now))
                .font(.headline)
            
            ZStack(alignment: .bottomTrailing) {
                    Image(book.genre ?? "Fantasy")
                        .resizable()
                        .scaledToFit()

                    Text(book.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)
            }
            
            Text(book.author ?? "Unknown author")
                .font(.title)
                .foregroundColor(.secondary)
            
            Text(book.review ?? "No Review")
                .padding()
            
            RatingView(rating: .constant(Int(book.rating)))
                .font(.largeTitle)
        }
        .navigationTitle(book.title ?? "Unknown Book")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                showingDeleteAlert = true
            } label: {
                Image(systemName: "trash")
            }
        }
        .alert("Delete Book", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                moc.delete(book)
                try? moc.save()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this book?")
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        let book = Book(context: moc)
        book.title = "Test book"
        book.author = "Test author"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "This was a great book; I really enjoyed it."

        return NavigationView {
            DetailView(book: book)
        }
    }
}
