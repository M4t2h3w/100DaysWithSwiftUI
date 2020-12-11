//
//  UserDetailView.swift
//  ChallengeDay60
//
//  Created by Matej Novotný on 23/10/2020.
//

import SwiftUI

struct InformationView: View {
    let header: String
    let information: String
    
    init(_ header: String, _ information: String) {
        self.header = header
        self.information = information
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.gray)
                .frame(maxHeight: 75)
                
            VStack {
                Text(header)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(information)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
            }
        }
    }
}

struct UserDetailView: View {
    
    let allUsers: FetchedResults<User>
    let user: User
    var body: some View {
        
        ScrollView {
        VStack(alignment: .leading) {
            HStack {
                InformationView("COMPANY:", self.user.company ?? "Unknown Company")
                InformationView("AGE:", "\(self.user.age)")
            }
            
            InformationView("E-MAIL:", self.user.email ?? "Unknown email")
            InformationView("ADDRESS:", self.user.address ?? "Unknown address")
            InformationView("REGISTERED FROM:", "\(self.user.formattedDate)")
            
            Text("ABOUT")
                .font(.headline)
            Text(self.user.about ?? "Unknown about")
                .font(.body)
                .padding(.bottom, 10)
            
            Text("TAGS")
                .font(.headline)
//            Text(returnAllTags(tagsArray: self.user.tags))
//                    .font(.body)
//                    .padding(.bottom, 5)
            
            Section(header: Text("FRIENDS").font(.headline)) {
                ForEach(self.user.friendsArray, id: \.id) {friend in
                    NavigationLink(destination: UserDetailView(allUsers: allUsers, user: returnUser(friendID: friend.id ?? UUID()))) {
                            Text(friend.name ?? "Unknown friend name")
                                .padding(5)
                    }
                }
            }
        }
        }
        .padding()
        .navigationBarTitle(Text(self.user.name ?? "Unknown User name"))
    }
    
    func returnUser(friendID: UUID) -> User {
        return allUsers.first(where: { $0.id == friendID }) ?? allUsers[1]
    }
    
    func returnAllTags(tagsArray: [String]) -> String {
        var result = ""
        
        for tag in tagsArray {
            result += tag + ", "
        }
        
        result.removeLast(2)
        
        return result
    }
}

//struct UserDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserDetailView()
//    }
//}
