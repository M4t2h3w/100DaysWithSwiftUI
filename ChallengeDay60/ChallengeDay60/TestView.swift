//
//  TestView.swift
//  ChallengeDay60
//
//  Created by Matej Novotný on 23/10/2020.
//

import SwiftUI

struct TestView: View {
    let databaseUsers: FetchedResults<User>
    let user: User
    
    var body: some View {
        VStack{
            Text(user.name ?? "Unknown name")
            
            ForEach(user.friendsArray, id: \.id) { friend in
                Text(friend.name ?? "Unknown friend")
            }
        }
    }
}

//struct TestView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestView()
//    }
//}
