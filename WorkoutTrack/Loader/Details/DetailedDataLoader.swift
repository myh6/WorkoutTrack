//
//  DetailedLoader.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/24.
//

import Foundation

public class DetailedDataLoader {
    private let store: DetailRetrievalStore
    
    public init(store: DetailRetrievalStore) {
        self.store = store
    }
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .failure(error):
                completion(.failure(error))
                
            case .empty:
                completion(.success([]))
                
            case let .found(detailsDTO):
                completion(.success(detailsDTO.toModels()))
            }
        }
    }
}

extension Array where Element == DetailedDTO {
    func toModels() -> [Detailed] {
        map { $0.toDomain() }
    }
}
