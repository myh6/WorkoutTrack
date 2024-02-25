//
//  ActionLoader.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/25.
//

import Foundation

public class ActionLoader {
    private let store: ActionRetrievalStore
    
    public init(store: ActionRetrievalStore) {
        self.store = store
    }
    
    public func loadAction(with predicate: NSPredicate? = nil, completion: @escaping (ActionRetrievalResult) -> Void) {
        store.retrieve(predicate: predicate, completion: completion)
    }
}

public enum ActionRetrievalResult {
    public struct ActionFeed: Equatable {
        let actionName: String
        let typeName: String
        
        public init(actionName: String, typeName: String) {
            self.actionName = actionName
            self.typeName = typeName
        }
    }
    
    case empty
    case failure(Error)
    case found(ActionFeed)
}
