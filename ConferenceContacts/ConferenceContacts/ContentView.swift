//
//  ContentView.swift
//  ConferenceContacts
//
//  Created by Matej Novotný on 06/11/2020.
//

import MapKit
import SwiftUI

struct ContentView: View {    
    @ObservedObject var allContacts: AllContacts = AllContacts()
    
    @State private var showingSheet = false
    @State private var newPictureAdded = false
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var firstName: String = ""
    @State private var surname: String = ""
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var anotation = MKPointAnnotation()
    
    let locationFetcher = LocationFetcher()
    
    var body: some View {
        
        if newPictureAdded {
            //view for adding name and surname to picture
            NavigationView {
                VStack {
                    image?
                        .resizable()
                        .frame(width: 300, height: 300)
                        .clipShape(Circle())
                        .shadow(radius: 2)
                        .padding(.horizontal)
                    TextField("First name", text: $firstName)
                    TextField("Surname", text: $surname)
                    
                    MapView(centerCoordinate: $centerCoordinate, annotation: anotation)
                    
                    Spacer()
                    HStack{
                        Button("Save") {
                            saveContact()
                            saveData()
                            self.firstName = ""
                            self.surname = ""
                            self.image = nil
                            self.inputImage = nil
                            loadData()
                            self.newPictureAdded = false
                        }
                        Button("Cancel") {
                            self.firstName = ""
                            self.surname = ""
                            self.image = nil
                            self.inputImage = nil
                            self.newPictureAdded = false
                        }
                    }
                }
                .padding()
                .navigationBarTitle(Text("Add new contact"))
        }
            
        } else {
            // List view of all contacts
            NavigationView {
                ZStack {
                        List {
                            ForEach(allContacts.contacts, id: \.id) { contact in
                                NavigationLink(destination: DetailContactView(contact: contact)){
                                    HStack {
                                        contact.image
                                            .resizable()
                                            .clipShape(Circle())
                                            .frame(width: 50, height: 50)
                                        Text(contact.firstName + " " + contact.surname)
                                            .font(.headline)
                                    }
                                }
                            }
                            .onDelete(perform: deleteContact)
                        }
                        
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: {
                                    self.showingSheet = true
                                    
                                }) {
                                    Image(systemName: "plus")
                                        .padding()
                                        .background(Color.black.opacity(0.75))
                                        .foregroundColor(.white)
                                        .font(.title)
                                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                        .padding(.trailing)
                                }
                            }
                        }
                }
                .navigationBarTitle(Text("Conference Contacts"))
                .sheet(isPresented: $showingSheet, onDismiss: loadImage, content: {
                    ImagePicker(image: self.$inputImage)
                })
            }
            .onAppear(perform: {
                loadData()
                locationFetcher.start()
            })
        }
    }
    
    func getCurrentLocation() {
        self.centerCoordinate = locationFetcher.lastKnownLocation ?? CLLocationCoordinate2D(latitude: 51.0, longitude: 0.0)
    }
    
    func loadPhoto(contact: Contact) -> Image {
        var image: Image = Image(systemName: "plus")
        let filename = getDocumentDirectory().appendingPathComponent("\(contact.id)")
        if let data = try? Data(contentsOf: filename) {
            guard let inputImage = UIImage(data: data) else { return Image(systemName: "plus") }
            image = Image(uiImage: inputImage)
        }
        return image
    }
    
    func saveContact(){
        let contact = Contact(id: UUID(), firstName: self.firstName, surname: self.surname, latitude: anotation.coordinate.latitude, longitude: anotation.coordinate.longitude)
        allContacts.contacts.append(contact)
        let filename = getDocumentDirectory().appendingPathComponent("\(contact.id)")

        if let jpegData = inputImage?.jpegData(compressionQuality: 0.8){
            try? jpegData.write(to: filename, options: [.atomicWrite, .completeFileProtection])
        }
    }
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func loadData() {
        let filename = getDocumentDirectory().appendingPathComponent("SavedContacts")
        
        do {
            let data = try Data(contentsOf: filename)
            allContacts.contacts = try JSONDecoder().decode([Contact].self, from: data)
            allContacts.contacts.sort()
            print("Load successful.")
        } catch {
            print("Unable to load saved data.")
        }
    }
    
    func saveData() {
        do {
            let filename = getDocumentDirectory().appendingPathComponent("SavedContacts")
            let data = try JSONEncoder().encode(self.allContacts.contacts)
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
            print("Save successful.")
        } catch {
            print("Unable to save data.")
        }
    }
    
    func deleteContact(at offsets: IndexSet) {
        for offset in offsets {
            allContacts.contacts.remove(at: offset)
            saveData()
            print("Contact deleted.")
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        self.newPictureAdded = true
        getCurrentLocation()
        anotation.coordinate = centerCoordinate
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(allContacts: AllContacts.example)
    }
}
