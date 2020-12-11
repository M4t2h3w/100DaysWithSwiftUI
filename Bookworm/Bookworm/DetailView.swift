//
//  DetailView.swift
//  Bookworm
//
//  Created by Matej Novotný on 21/10/2020.
//

import CoreData
import SwiftUI

struct DetailView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
    var formattedDate: String {
        if let date = self.book.date {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            
            return formatter.string(from: date)
        } else {
            return "N/A"
        }
    }
    
    let book: Book
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    if self.book.genre == "Unknown" {
                        Image(systemName: "questionmark")
                            .frame(maxWidth: geometry.size.width)
                            .font(.largeTitle)
                            .padding()

                    } else {
                        Image(self.book.genre ?? "Fantasy")
                            .frame(maxWidth: geometry.size.width)
                    }
                    
                    Text(self.book.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)
                }
                
                Text(self.book.author ?? "Unknown author")
                    .font(.title)
                    .foregroundColor(.secondary)
                Text(formattedDate)
                    .font(.caption)
                Text(self.book.review ?? "No review")
                    .padding()
                
                RatingView(rating: .constant(Int(self.book.rating)))
                    .font(.largeTitle)
                Spacer()
                
            }
        }
        .navigationBarTitle(Text(book.title ?? "Unknown Book"), displayMode: .inline)
        .alert(isPresented: $showingDeleteAlert, content: {
            Alert(title: Text("Delete book"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")) {
                self.deleteBook()
            }, secondaryButton: .cancel())
        })
        .navigationBarItems(trailing: Button(action: {
            self.showingDeleteAlert = true
        }){
            Image(systemName: "trash")
        })
    }
    
    func deleteBook() {
        moc.delete(book)
//        uncomment the line below to make the changes permanent
//        try? self.moc.save()
        
        presentationMode.wrappedValue.dismiss()
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
        book.review = "I really enjoyed it."
        
        return NavigationView{
            DetailView(book: book)
        }
    }
}
