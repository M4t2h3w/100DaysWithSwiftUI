//
//  Prospect.swift
//  HotProspects
//
//  Created by Matej Novotný on 16/11/2020.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
}

class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    static let saveKey = "SavedData"
    
    init() {
//        if let data = UserDefaults.standard.data(forKey: Self.saveKey) {
//            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
//                self.people = decoded
//                return
//            }
//        }
        self.people = []
        
        //LOAD DATA FROM DIRECTORY
        do {
            let filename = getDocumentsDirectory().appendingPathComponent(Self.saveKey)
            let data = try Data(contentsOf: filename)
            let decoded = try JSONDecoder().decode([Prospect].self, from: data)
            self.people = decoded
        } catch {
            print("Unable to load the data")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func save() {
        do {
            let filename = getDocumentsDirectory().appendingPathComponent(Self.saveKey)
            let encoded = try JSONEncoder().encode(people)
            try encoded.write(to: filename, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
}
