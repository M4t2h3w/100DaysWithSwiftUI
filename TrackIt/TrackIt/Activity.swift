//
//  Activity.swift
//  TrackIt
//
//  Created by Matej Novotný on 15/10/2020.
//

import Foundation

struct Activity: Codable, Identifiable {
    let id = UUID()
    let activityName: String
    let activityDescription: String
}
