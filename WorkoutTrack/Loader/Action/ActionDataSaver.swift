//
//  LocalActionFeedLoader.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/2/5.
//

import Foundation

public class ActionDataSaver: ActionSaver {
    private let store: ActionAdditionStore
    
    public init(store: ActionAdditionStore) {
        self.store = store
    }
    
    public func save(action: AddActionModel, completion: @escaping (ActionSaver.Result) -> Void) {
        store.addAction(action: [action.toLocal()]) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
}
