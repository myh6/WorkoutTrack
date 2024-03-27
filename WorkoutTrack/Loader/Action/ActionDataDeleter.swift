//
//  ActionDataDeleter.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/3/24.
//

import Foundation

public class ActionDataDeleter: ActionDeleter {
    
    private let store: ActionRemovalStore
    
    public init(store: ActionRemovalStore) {
        self.store = store
    }
    
    public func delete(action: UUID, completion: @escaping (ActionDeleter.Result) -> Void) {
        store.remove(actionID: action) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
}
