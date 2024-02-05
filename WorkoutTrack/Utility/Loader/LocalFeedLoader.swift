//
//  LocalFeedLoader.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/2/4.
//

public class LocalFeedLoader {
    let store: LocalFeedStore
    
    public typealias DetailResult = Error?
    public typealias ActionResult = Error?
    
    public init(store: LocalFeedStore) {
        self.store = store
    }
    
    public func save(details: [Detailed], completion: @escaping (DetailResult) -> Void) {
        store.addData(details: details.toLocal()) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
    
    public func save(action: String, ofType: String, completion: @escaping (ActionResult) -> Void) {
        store.addAction(actionName: action, ofType: ofType) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
}
