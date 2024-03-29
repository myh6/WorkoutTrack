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
    public let id: UUID
    public let actionName: String
    public let typeName: String
    public let isOpen: Bool
    
    public let details: [DetailedDTO]
    
    public init(id: UUID, actionName: String, typeName: String, isOpen: Bool, details: [DetailedDTO]) {
        self.id = id
        self.actionName = actionName
        self.typeName = typeName
        self.isOpen = isOpen
        self.details = details
    }
}
public typealias ActionRetrievalResult = Result<[ActionDTO], Error>
