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

public struct ActionFeed: Equatable {
    let actionName: String
    let typeName: String
    
    public init(actionName: String, typeName: String) {
        self.actionName = actionName
        self.typeName = typeName
    }
}
public typealias ActionRetrievalResult = Result<[ActionFeed], Error>
