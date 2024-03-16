//
//  DetailedDataDeleter.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/3/16.
//

import Foundation

public class DetailedDataDeleter: DetailedDeleter {
    private let store: DetailRemovalStore
    
    public init(store: DetailRemovalStore) {
        self.store = store
    }
    
    public func delete(details: [Detailed], completion: @escaping (DeleteDetailedResult) -> Void) {
        store.remove(details: details.toLocal()) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
}
