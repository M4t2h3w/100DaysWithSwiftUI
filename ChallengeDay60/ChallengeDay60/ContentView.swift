//
//  ContentView.swift
//  ChallengeDay60
//
//  Created by Matej Novotný on 22/10/2020.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var databaseUsers: FetchedResults<User>
    
    var body: some View {
        NavigationView {
            VStack {
                
                List {
                    ForEach(databaseUsers, id: \.self) { user in
                        NavigationLink(destination: UserDetailView(allUsers: databaseUsers, user: user)) {
                            VStack(alignment: .leading) {
                                Text(user.name ?? "Unknown")
                                    .font(.headline)
                                Text(user.company ?? "Unknown")
                                    .font(.body)
                            }
                        }
                    }
                    .onDelete(perform: deleteUser)
                }
            }
            .navigationBarTitle(Text("iFriends"))
        }
    }
    
    func deleteUser(at offsets: IndexSet) {
        for offset in offsets {
            let user = databaseUsers[offset]
            moc.delete(user)
        }
        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}
