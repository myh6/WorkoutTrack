//
//  DetailedDTO.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/2/4.
//

import Foundation

// MARK: - Data Transfer Object
public struct DetailedDTO: Equatable {
    
    public var uuid: UUID
    public var weight: Float
    public var isDone: Bool
    public var reps: Int
    
    public init(uuid: UUID, weight: Float, isDone: Bool, reps: Int) {
        self.uuid = uuid
        self.weight = weight
        self.isDone = isDone
        self.reps = reps
    }
    
    public func toDomain() -> Detailed {
        return Detailed(uid: uuid, setName: "", weight: weight, isDone: isDone, reps: reps, id: uuid.uuidString)
    }
}

public extension Array where Element == Detailed {
    func toLocal() -> [DetailedDTO] {
        self.map {
            DetailedDTO(uuid: $0.uid, weight: $0.weight, isDone: $0.isDone, reps: $0.reps)
        }
    }
}
