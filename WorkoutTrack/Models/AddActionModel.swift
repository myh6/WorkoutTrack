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

public struct Detailed: Equatable {
    
    var setName: String
    var weight: Float
    var isDone: Bool
    var reps: Int
    var id: String
    var uid: UUID
    
    public init(uid: UUID = UUID(), setName: String, weight: Float, isDone: Bool, reps: Int, id: String) {
        self.uid = uid
        self.setName = setName
        self.weight = weight
        self.isDone = isDone
        self.reps = reps
        self.id = id
    }
    
}
