//
//  DetailedDataUpdater.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/3/1.
//

import Foundation

public class DetailedDataUpdater: DetailedUpdater {
    private let store: DetailUpdateStore
    
    public init(store: DetailUpdateStore) {
        self.store = store
    }
    
    public func updateDetailed(_ detail: Detailed, completion: @escaping (Error?) -> Void) {
        store.update(detail: detail.toLocal()) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
}
