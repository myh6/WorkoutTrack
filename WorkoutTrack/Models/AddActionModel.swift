//
//  AddActionModel.swift
//  WorkoutTrack
//
//  Created by Min-Yang Huang on 2022/4/25.
//

import Foundation

public struct AddActionModel {
    
    var id: UUID
    var moveName: String
    var ofType: String
    var detail: [Detailed]
    var isOpen: Bool = true
    #warning("Give a default ID to make old implementation passed for now")
    public init(id: UUID = UUID(), moveName: String, ofType: String, detail: [Detailed], isOpen: Bool) {
        self.id = id
        self.moveName = moveName
        self.ofType = ofType
        self.detail = detail
        self.isOpen = isOpen
    }
    
}

public extension AddActionModel {
    func toLocal() -> ActionDTO {
        let detailDTOs = detail.map { $0.toLocal() }
        return ActionDTO(id: id, actionName: moveName, typeName: ofType, isOpen: isOpen, details: detailDTOs)
    }
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

public extension Detailed {
    func toLocal() -> DetailedDTO {
        return DetailedDTO(uuid: uid, weight: weight, isDone: isDone, reps: reps)
    }
}
