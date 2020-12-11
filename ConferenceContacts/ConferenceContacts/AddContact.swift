//
//  AddContact.swift
//  ConferenceContacts
//
//  Created by Matej Novotný on 06/11/2020.
//

import SwiftUI

struct AddContact: View {
    @State private var firstName: String = ""
    @State private var surname: String = ""
    var allContacts: AllContacts
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Circle()
                    .stroke(Color.blue, lineWidth: 2)
                    .frame(width: 300, height: 300)
                    .padding(.horizontal)
                TextField("First name", text: $firstName)
                TextField("Surname", text: $surname)
                Spacer()
            }
            .padding(.horizontal)
            .navigationBarTitle(Text("\(firstName) \(surname)"))
            .navigationBarItems(leading: Button("Cancel") {
                self.presentationMode.wrappedValue.dismiss()
            },
                trailing: Button("Save") {
                saveContact()
                saveData()
                self.presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    func saveContact(){
        let contact = Contact(firstName: self.firstName, surname: self.surname, pictureNumber: 3)
        allContacts.contacts.append(contact)
    }
    
    func getDocumnetDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveData() {
        do {
            let filename = getDocumnetDirectory().appendingPathComponent("SavedContacts")
            let data = try JSONEncoder().encode(self.allContacts.contacts)
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
            print("Save successful.")
        } catch {
            print("Unable to save data.")
        }
    }
}

struct AddContact_Previews: PreviewProvider {
    static var previews: some View {
        AddContact(allContacts: AllContacts.example)
    }
}
