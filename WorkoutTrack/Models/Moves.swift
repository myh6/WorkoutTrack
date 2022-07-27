//
//  Moves.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/4/24.
//

import Foundation

struct Move: Codable {
    
    let Legs: Array<String>
    let Chest: Array<String>
    let Back: Array<String>
    let Arms: Array<String>
    let Shoulder: Array<String>
    let Abs: Array<String>
    let Glutes: Array<String>
    
}


final class Moves {
    
    static let shared = Moves()
    func getDBMenu(completion: @escaping(Move?) -> Void ) {
        let url = Bundle.main.url(forResource: "Moves", withExtension: "plist")!
        if let data = try? Data(contentsOf: url), let move = try? PropertyListDecoder().decode(Move.self, from: data) {
            completion(move)
        } else {
            completion(nil)
        }
    }
    
}
