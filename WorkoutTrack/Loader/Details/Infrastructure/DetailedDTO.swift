//
//  DetailedDTO.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/2/4.
//

import Foundation

// MARK: - Data Transfer Object
public struct DetailedDTO: Equatable, Hashable {
    
    public let uuid: UUID
    public let weight: Float
    public let isDone: Bool
    public let reps: Int
    public let time: Date
    
    public init(uuid: UUID, weight: Float, isDone: Bool, reps: Int, time: Date) {
        self.uuid = uuid
        self.weight = weight
        self.isDone = isDone
        self.reps = reps
        self.time = time
    }
    
    public func toDomain() -> Detailed {
        return Detailed(uid: uuid, setName: "", weight: weight, isDone: isDone, reps: reps, id: uuid.uuidString, time: time)
    }
}

public extension Array where Element == Detailed {
    func toLocal() -> [DetailedDTO] {
        self.map {
            DetailedDTO(uuid: $0.uid, weight: $0.weight, isDone: $0.isDone, reps: $0.reps, time: $0.time)
        }
    }
}
