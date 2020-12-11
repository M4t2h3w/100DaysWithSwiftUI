//
//  AddActivity.swift
//  TrackIt
//
//  Created by Matej Novotný on 15/10/2020.
//

import SwiftUI

struct AddActivity: View {
    @ObservedObject var allActivities: AllActivities
    @State private var name = ""
    @State private var description = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                TextField("Description", text: $description)
            }
            
        .navigationBarTitle("Add Activity")
                .navigationBarItems(
                    trailing: Button("Save") {
                        if !name.isEmpty {
                            let activity = Activity(activityName: self.name, activityDescription: self.description)
                            self.allActivities.activities.append(activity)
                            self.presentationMode.wrappedValue.dismiss()
                        } else {
                            showingAlert = true
                        }
                    }
                )
        }
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text("Missing name"), message: Text("Unable to save activity without name"), dismissButton: .default(Text("Continue")))
        })
    }
}

struct AddActivity_Previews: PreviewProvider {
    static var previews: some View {
        AddActivity(allActivities: AllActivities())
    }
}
