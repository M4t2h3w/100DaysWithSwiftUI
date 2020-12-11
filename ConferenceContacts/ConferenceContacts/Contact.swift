//
//  Contact.swift
//  ConferenceContacts
//
//  Created by Matej Novotný on 06/11/2020.
//

import Foundation
import SwiftUI

struct Contact: Codable, Comparable {
    let id: UUID
    let firstName: String
    let surname: String
    let latitude: Double
    let longitude: Double
    var image: Image {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        var image: Image = Image(systemName: "plus")
        let filename = paths[0].appendingPathComponent("\(self.id)")
        if let data = try? Data(contentsOf: filename) {
            guard let inputImage = UIImage(data: data) else { return Image(systemName: "plus") }
            image = Image(uiImage: inputImage)
        }
        return image
    }
    
    static func < (lhs: Contact, rhs: Contact) -> Bool {
        lhs.surname < rhs.surname
    }
}

class AllContacts: ObservableObject {
    @Published var contacts: [Contact]
    
    init() {
        self.contacts = []
    }
    
    init(allContacts: [Contact]) {
        self.contacts = allContacts
    }
}

extension AllContacts {
    static var example: AllContacts {
        let allContacts = AllContacts()
        let contact1 = Contact(id: UUID(), firstName: "Fero", surname: "Dajaky", latitude: 51.0, longitude: 10.0)
        let contact2 = Contact(id: UUID(), firstName: "Jozef", surname: "Onaky", latitude: 51.0, longitude: 0.0)
        
        allContacts.contacts.append(contact1)
        allContacts.contacts.append(contact2)
        
        return allContacts
    }
}
