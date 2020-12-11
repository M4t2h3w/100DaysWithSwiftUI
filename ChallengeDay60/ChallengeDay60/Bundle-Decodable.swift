//
//  Bundle-Decodable.swift
//  ChallengeDay60
//
//  Created by Matej Novotný on 23/10/2020.
//

import Foundation

extension Bundle {
    func decode(stringUrl: String) -> [JUser] {
        if let url = URL(string: stringUrl) {
            if let data = try? Data(contentsOf: url){
                print("Load success")
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                if let jsonUsers = try? decoder.decode([JUser].self, from: data) {
                    print("Parsing success")
                    return jsonUsers
                } else {
                    print("Parsing unsuccessful")
                }
                
            } else {
                print("Loading failed")
            }
        }
        return []
    }
}
