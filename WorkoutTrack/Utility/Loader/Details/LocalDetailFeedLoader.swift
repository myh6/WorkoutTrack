//
//  LocalFeedLoader.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/2/4.
//

// TODO: - Better naming option: DetailedDataSaver, DetailedDataRepository
// This class should comform to a protocol to keep business domain agnostic
// FeedLoader --> Business Domain ( So that Business Domain wouldn't know where the data is from)

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
