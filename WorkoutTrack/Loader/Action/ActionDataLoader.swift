//
//  ActionDataLoader.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/2/25.
//

import Foundation

public class ActionDataLoader: ActionLoader {
    private let store: ActionRetrievalStore
    
    public init(store: ActionRetrievalStore) {
        self.store = store
    }
    
    public func loadAction(with predicate: NSPredicate? = nil, completion: @escaping (ActionRetrievalResult) -> Void) {
        store.retrieve(predicate: predicate, completion: completion)
    }
}
