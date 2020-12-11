//
//  User+CoreDataProperties.swift
//  ChallengeDay60
//
//  Created by Matej Novotný on 23/10/2020.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var isActive: Bool
    @NSManaged public var name: String?
    @NSManaged public var age: Int16
    @NSManaged public var company: String?
    @NSManaged public var email: String?
    @NSManaged public var address: String?
    @NSManaged public var about: String?
    @NSManaged public var registered: Date?
    @NSManaged public var friends: NSSet?
    
    public var friendsArray: [Friend] {
        let set = friends as? Set<Friend> ?? []
        
        return set.sorted {
            $0.name ?? "unknown" < $1.name ?? "unknown"
        }
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        return formatter.string(from: registered ?? Date())
    }
    
    func transferJUserToDatabase(jUser: JUser) {
        self.id = jUser.id
        self.isActive = jUser.isActive
        self.name = jUser.name
        self.age = Int16(jUser.age)
        self.company = jUser.company
        self.email = jUser.email
        self.address = jUser.address
        self.about = jUser.about
        self.registered = jUser.registered
    }

}

// MARK: Generated accessors for friends
extension User {

    @objc(addFriendsObject:)
    @NSManaged public func addToFriends(_ value: Friend)

    @objc(removeFriendsObject:)
    @NSManaged public func removeFromFriends(_ value: Friend)

    @objc(addFriends:)
    @NSManaged public func addToFriends(_ values: NSSet)

    @objc(removeFriends:)
    @NSManaged public func removeFromFriends(_ values: NSSet)

}

extension User : Identifiable {

}
