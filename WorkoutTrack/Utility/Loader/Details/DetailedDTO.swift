//
//  DetailedDTO.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/2/4.
//

import Foundation

// MARK: - Data Transfer Object
public struct DetailedDTO: Equatable {
    
    var uuid: UUID
    var setName: String
    var weight: Float
    var isDone: Bool
    var reps: Int
    var id: String
    
    public init(uuid: UUID, setName: String, weight: Float, isDone: Bool, reps: Int, id: String) {
        self.uuid = uuid
        self.setName = setName
        self.weight = weight
        self.isDone = isDone
        self.reps = reps
        self.id = id
    }
    
    public func toDomain() -> Detailed {
        return Detailed(uid: uuid, setName: setName, weight: weight, isDone: isDone, reps: reps, id: id)
    }
}

public extension Array where Element == Detailed {
    func toLocal() -> [DetailedDTO] {
        self.map {
            DetailedDTO(uuid: $0.uid, setName: $0.setName, weight: $0.weight, isDone: $0.isDone, reps: $0.reps, id: $0.id)
        }
    }
}
