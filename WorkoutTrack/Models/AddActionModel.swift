//
//  AddActionModel.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/4/25.
//

import Foundation

struct AddActionModel {
    
    var moveName: String
    var ofType: String
    var detail: [Detailed]
    var isOpen: Bool = true
    
}

struct Detailed {
    
    var setName: String
    var weight: Float
    var isDone: Bool
    var reps: Int
    var id: String
    
}
