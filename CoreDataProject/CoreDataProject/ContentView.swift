//
//  ContentView.swift
//  CoreDataProject
//
//  Created by Matej Novotný on 21/10/2020.
//

import CoreData
import SwiftUI

//if all variables in struct conforms to Hashable whole struct conforms to Hashable
struct Student: Hashable {
    let name: String // String conforms to hashable
}

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: Country.entity(), sortDescriptors: []) var countries: FetchedResults<Country>
    
    @State var filterValue  = ""
    
    @FetchRequest(entity: Ship.entity(), sortDescriptors: [], predicate: NSPredicate(format: "universe == %@", "Star Wars")) var ships: FetchedResults<Ship>
    
    @FetchRequest(entity: Wizard.entity(), sortDescriptors: []) var wizards: FetchedResults<Wizard>
    @FetchRequest(entity: Movie.entity(), sortDescriptors: []) var movies: FetchedResults<Movie>
    
    let sortDescriptors = [NSSortDescriptor(keyPath: \Singer.lastName, ascending: true), NSSortDescriptor(keyPath: \Singer.lastName, ascending: true)]
    @State var filterKey = "lastName"
    
    let availableFilterKeys = ["lastName", "firstName"]
    
    
    let students = [Student(name: "Harry Potter"), Student(name: "Hermione Granger")]
    var body: some View {
        
//        VStack {
//            List {
//                ForEach(countries, id: \.self) { country in
//                    Section(header: Text(country.wrappedFullName)) {
//                        ForEach(country.candyArray, id: \.self) {candy in
//                            Text(candy.wrappedName)
//                        }
//                    }
//                }
//            }
//
//            Button("Add") {
//                let candy1 = Candy(context: self.moc)
//                candy1.name = "Mars"
//                candy1.origin = Country(context: self.moc)
//                candy1.origin?.shortName = "UK"
//                candy1.origin?.fullName = "United Kingdom"
//
//                let candy2 = Candy(context: self.moc)
//                candy2.name = "KitKat"
//                candy2.origin = Country(context: self.moc)
//                candy2.origin?.shortName = "UK"
//                candy2.origin?.fullName = "United Kingdom"
//
//                let candy3 = Candy(context: self.moc)
//                candy3.name = "Twix"
//                candy3.origin = Country(context: self.moc)
//                candy3.origin?.shortName = "UK"
//                candy3.origin?.fullName = "United Kingdom"
//
//                let candy4 = Candy(context: self.moc)
//                candy4.name = "Toblerone"
//                candy4.origin = Country(context: self.moc)
//                candy4.origin?.shortName = "CH"
//                candy4.origin?.fullName = "Switzerland"
//
//                try? self.moc.save()
//            }
//        }
        
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .offset(x: 10)
                
                TextField("Filter singers", text: $filterValue)
                    .padding()
            }
            
            Picker(selection: $filterKey, label: Text("Select filter")) {
                ForEach(availableFilterKeys, id: \.self) { filter in
                    Text(filter)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            FilteredList(filterKey: filterKey, filterValue: filterValue, sortDescriptors: sortDescriptors) {(singer: Singer) in
                Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
            }

            Button("Add Examples") {
                let taylor = Singer(context: self.moc)
                taylor.firstName = "Taylor"
                taylor.lastName = "Swift"

                let ed = Singer(context: moc)
                ed.firstName = "Ed"
                ed.lastName = "Sheeran"

                let adele = Singer(context: moc)
                adele.firstName = "Adele"
                adele.lastName = "Adkins"

                try? self.moc.save()
            }

            Button("Show A") {
                self.filterValue = "A"
            }

            Button("Show S") {
                self.filterValue = "S"
            }
        }
        
//        VStack {
//            List(ships, id: \.self) { ship in
//                Text(ship.name ?? "Unknown name")
//            }
//            
//            Button("Add Examples") {
//                let ship = Ship(context: self.moc)
//                ship.name = "Enterprise"
//                ship.universe = "Star Trek"
//                
//                let ship2 = Ship(context: self.moc)
//                ship2.name = "Defiant"
//                ship2.universe = "Star Trek"
//                
//                let ship3 = Ship(context: moc)
//                ship3.name = "Millenium Falcon"
//                ship3.universe = "Star Wars"
//                
//                let ship4 = Ship(context: moc)
//                ship4.name = "Executor"
//                ship4.universe = "Star Wars"
//                
//                try? self.moc.save()
//            }
//        }
        
//        VStack {
//        since Student conforms to hashable we can use \.self as id
//        even if we will create 2 identical Students, their hash will be different since
//        Swift adds some other values to them and calculate hash together
//            List(students, id: \.self) { student in
//                Text(student.name)
//            }
            
//            Section{
//                List(wizards, id: \.self) {wizard in
//                    Text(wizard.name ?? "Unknown")
//                }
//                Button("Add Wizard") {
//                    let wizard = Wizard(context: self.moc)
//                    wizard.name = "Harry Potter"
//                }
//                Button("Save Wizards") {
//                    do {
//                        try self.moc.save()
//                    } catch {
//                        print(error.localizedDescription)
//                    }
//                }
//            }
//
//            Section {
//                List {
//                    ForEach(movies, id: \.self) {movie in
//                        HStack {
//                            Text(movie.title ?? "Unknown")
//                                .font(.title)
//                            Spacer()
//                            VStack {
//                                Text(movie.director ?? "Unknown")
//                                Text("\(movie.year)")
//                            }
//                        }
//                    }
//                    .onDelete(perform: deleteMovie)
//                }
//
//                Button("Add movie") {
//                    let movie = Movie(context: self.moc)
//                    movie.title = "The Godfather"
//                    movie.director = "Director"
//                    movie.year = 1985
//                }
//
//                Button("Save Movies") {
//    //                it is good practice to check if there are any changes before saving to CoreData
//                    if self.moc.hasChanges {
//                        try? self.moc.save()
//                        print ("Saving changes")
//                    } else {
//                        print("Not saving...")
//                    }
//                }
//            }
//        }
//    }
//
//    func deleteMovie(at offsets: IndexSet){
//        for offset in offsets {
//            let movie = movies[offset]
//            moc.delete(movie)
//        }
//
//        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
