//
//  ContentView.swift
//  Moonshot
//
//  Created by Matej Novotný on 12/10/2020.
//

import SwiftUI

struct ContentView: View {
    
    let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    @State private var crewOrLaunch = true
    
    var body: some View {
        NavigationView {
            List(missions) { mission in
                NavigationLink(
                    destination: MissionView(mission: mission, astronauts: self.astronauts, allMissions: missions)) {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                    
                    VStack(alignment: .leading){
                        Text(mission.displayName)
                            .font(.headline)
//                        Text(mission.formattedLaunchDate)
                        Text(crewOrLaunch ? mission.formattedLaunchDate : getAstronautsNames(mission: mission))
                    }
                }
            }
            .navigationBarTitle("Moonshot")
            .navigationBarItems(trailing: Button(crewOrLaunch ? "Show crew" : "Show date"){
                self.crewOrLaunch.toggle()
            })
        }
    }
    
    func getAstronautsNames(mission: Mission) -> String {
        var result = ""
        
        for member in mission.crew {
            result += member.name.capitalized + " | "
        }
        
        result.removeLast(3)
        
        return result
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
