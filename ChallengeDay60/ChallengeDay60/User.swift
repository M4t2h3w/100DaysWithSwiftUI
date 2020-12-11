//
//  User.swift
//  ChallengeDay60
//
//  Created by Matej Novotný on 23/10/2020.
//

import Foundation

struct JUser: Identifiable, Codable {
    let id: UUID
    let isActive: Bool
    let name: String
    let age: Int
    let company: String
    let email: String
    let address: String
    let about: String
    let registered: Date
    let tags: [String]
    let friends: [JFriend]
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        return formatter.string(from: registered)
    }
}
