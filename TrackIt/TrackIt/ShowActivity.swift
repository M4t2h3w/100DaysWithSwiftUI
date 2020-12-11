//
//  ShowActivity.swift
//  TrackIt
//
//  Created by Matej Novotný on 15/10/2020.
//

import SwiftUI

struct ShowActivity: View {
    @ObservedObject var allActivities: AllActivities
    var activity: Activity
    @State private var counter = 3
    
    var body: some View {

        List {
            Section(header: Text("Description")) {
                Text(self.activity.activityDescription)
            }
            Section(header: Text("Activity counter")){
                HStack {
                    Spacer()
                    
                    Button(action: {
                        if counter > 0 {
                            counter -= 1
                        }
                    }) {
                        Image(systemName: "minus")
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            .frame(width: 30, height: 30)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    
                    Spacer()
                    
                    Text("\(counter)")
                        .font(.largeTitle)
                    Spacer()
                    
                    Button(action: {
                        counter += 1
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.blue)
                            .frame(width: 30, height: 30)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    Spacer()
                }
            }
        }
        .navigationBarTitle(self.activity.activityName)
        .onAppear {
            self.counter = self.activity.activityCounter
        }
        .onDisappear {
            updateCounter()
        }
    }
    
    func updateCounter() {
        if let indexItem = allActivities.activities.firstIndex(where: { (activity) -> Bool in
            activity == self.activity
        }) {
            let tempActivity = Activity(activityName: self.activity.activityName, activityDescription: self.activity.activityDescription, activityCounter: self.counter)
            self.allActivities.activities.remove(at: indexItem)
            self.allActivities.activities.insert(tempActivity, at: indexItem)
        }
    }
}

struct ShowActivity_Previews: PreviewProvider {

    static var previews: some View {
        ShowActivity(allActivities: AllActivities(), activity: Activity(activityName: "Pokus", activityDescription: "Popis pokusu"))
    }
}
