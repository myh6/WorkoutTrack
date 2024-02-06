//
//  LocalFeedLoader.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/2/4.
//

public class LocalDetailFeedLoader {
    let store: LocalDetailFeedStore
    
    public typealias SaveDetailResult = Error?
    
    public init(store: LocalDetailFeedStore) {
        self.store = store
    }
    
    public func save(details: [Detailed], completion: @escaping (SaveDetailResult) -> Void) {
        store.addData(details: details.toLocal()) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
}
