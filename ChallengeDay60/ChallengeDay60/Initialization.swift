//
//  Initialization.swift
//  ChallengeDay60
//
//  Created by Matej Novotný on 23/10/2020.
//

import Foundation
import CoreData

class Initialize: ObservableObject {
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        let request: NSFetchRequest<User> = User.fetchRequest()
        let count = (try? context.fetch(request).count) ?? 0
        
        print("Core database user count: \(count)")
        
        // if the user count in database is 0, load data to database from URL
        if(count == 0) {
            
            // download and create users from JSON file
            let allUsers: [JUser] = Bundle.main.decode(stringUrl: "https://www.hackingwithswift.com/samples/friendface.json")
            
            //transfer JUsers to database
            for jUser in allUsers {
                let user = User(context: context)
                user.transferJUserToDatabase(jUser: jUser)
                
                for jFriend in jUser.friends {
                    let friend = Friend(context: context)
                    friend.id = jFriend.id
                    friend.name = jFriend.name
                    
                    user.addToFriends(friend)
                }
                
                try? self.context.save()
            }
        }
    }
}
