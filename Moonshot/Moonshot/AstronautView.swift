//
//  AstronautView.swift
//  Moonshot
//
//  Created by Matej Novotný on 13/10/2020.
//

import SwiftUI

struct AstronautView: View {
    
    let astronaut: Astronaut
    let activeMissions: [Mission]
    
    var body: some View {
        GeometryReader { geometry in
                ScrollView(.vertical){
                    VStack {
                        Image(self.astronaut.id)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width)
                        
                        Text(self.astronaut.description)
                            .padding()
    //                        if the text is not showing full and ending with ... just change the priority of the layout with code below
    //                        default is 0 meaning, that all layouts will have same chance to occupy the free space
                            .layoutPriority(1)
                        
                        ForEach(activeMissions){ mission in
//                            NavigationLink(destination: Text("TODO")) {
                                HStack(alignment: .center){
                                    Image(mission.image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 44, height: 44)
                                    VStack(alignment: .leading){
                                        Text(mission.displayName)
                                            .font(.headline)
                                        Text(mission.formattedLaunchDate)
                                    }
                                }
//                            }
                            .frame(maxWidth: geometry.size.width * 0.95, alignment: .leading)
                        }
                    }
                }
        }
        .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
    }
    
    init(astronaut: Astronaut, missions: [Mission]) {
        self.astronaut = astronaut
        
        var matches = [Mission]()
        
        for mission in missions {
            if mission.crew.first(where: { $0.name == astronaut.id }) != nil {
                matches.append(mission)
            }
        }
        self.activeMissions = matches
    }
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    static let missions: [Mission] = Bundle.main.decode("missions.json")

    static var previews: some View {
        AstronautView(astronaut: astronauts[13], missions: missions)
    }
}
