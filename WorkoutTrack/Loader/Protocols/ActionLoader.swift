//
//  ActionLoader.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/25.
//

import Foundation

public protocol ActionLoader {
    func loadAction(with predicate: NSPredicate?, completion: @escaping (ActionRetrievalResult) -> Void)
}

public extension ActionLoader {
    func loadAction(completion: @escaping (ActionRetrievalResult) -> Void) {
        loadAction(with: nil, completion: completion)
    }
}

/// DTO of AddActinoModel
public struct ActionDTO: Equatable {
    let id: UUID
    let actionName: String
    let typeName: String
    let isOpen: Bool
    
    let details: [DetailedDTO]
    
    public init(id: UUID, actionName: String, typeName: String, isOpen: Bool, details: [DetailedDTO]) {
        self.id = id
        self.actionName = actionName
        self.typeName = typeName
        self.isOpen = isOpen
        self.details = details
    }
}
public typealias ActionRetrievalResult = Result<[ActionDTO], Error>
