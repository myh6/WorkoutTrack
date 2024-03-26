//
//  LocalFeedLoader.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/2/4.
//
import Foundation

public class DetailedDataSaver: DetailedSaver {
    
    let store: DetailAdditionStore
    
    public init(store: DetailAdditionStore) {
        self.store = store
    }
    
    public func save(details: [Detailed], to action: UUID, completion: @escaping (DetailedSaver.Result) -> Void) {
        store.add(details: details.toLocal(), toActionWithID: action) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
}
