//
//  ContentView.swift
//  TrackIt
//
//  Created by Matej Novotný on 15/10/2020.
//

import SwiftUI

struct Activity: Codable, Identifiable {
    let id = UUID()
    let activityName: String
    let activityDescription: String
    var activityCounter: Int = 0
    
    static func == (lhs: Activity, rhs: Activity) -> Bool {
        return lhs.id == rhs.id
    }
}

class AllActivities: ObservableObject {
    @Published var activities = [Activity]() {
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(activities) {
                UserDefaults.standard.set(encoded, forKey: "Activities")
            }
        }
    }
    
    init() {
        if let activities = UserDefaults.standard.data(forKey: "Activities") {
            let decoder = JSONDecoder()
            
            if let decoded = try? decoder.decode([Activity].self, from: activities){
                self.activities = decoded
                return
            }
        }
        self.activities = []
    }
}

struct ContentView: View {
    
    @ObservedObject var allActivities = AllActivities()
    @State var showingAddActivity = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(allActivities.activities){ activity in
                    NavigationLink(destination: ShowActivity(allActivities: allActivities, activity: activity)){
                    HStack{
                        Text(activity.activityName)
                            .font(.headline)
                        Spacer()
                        Text("\(activity.activityCounter)")
                    }
                }
            }
                .onDelete(perform: removeActivity)
            }
            .navigationBarTitle("Track It")
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button(action: {
                    self.showingAddActivity = true
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $showingAddActivity) {
                AddActivity(allActivities: allActivities)
            }
        }
    }
    
    func removeActivity(at offsets: IndexSet){
        allActivities.activities.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
