//
//  Friend+CoreDataProperties.swift
//  ChallengeDay60
//
//  Created by Matej Novotný on 23/10/2020.
//
//

import Foundation
import CoreData


extension Friend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Friend> {
        return NSFetchRequest<Friend>(entityName: "Friend")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?

}

extension Friend : Identifiable {

}
