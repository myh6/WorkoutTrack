//
//  LocalActionFeedLoader.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/2/5.
//

import Foundation

public class LocalActionFeedLoader {
    let store: LocalActionFeedStore
    
    public typealias SaveActionResult = Error?
    
    public init(store: LocalActionFeedStore) {
        self.store = store
    }
    
    public func save(action: String, ofType: String, completion: @escaping (SaveActionResult) -> Void) {
        store.addAction(actionName: action, ofType: ofType) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
}
