//
//  LocalFeedLoader.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/2/4.
//

public class DetailedDataSaver: DetailedSaver {
    let store: DetailAdditionStore
    
    public init(store: DetailAdditionStore) {
        self.store = store
    }
    
    public func save(details: [Detailed], completion: @escaping (DetailedSaver.Result) -> Void) {
        store.add(details: details.toLocal()) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
}
