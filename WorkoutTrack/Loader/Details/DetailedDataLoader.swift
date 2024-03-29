//
//  DetailedLoader.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/24.
//

import Foundation

// While having predicate param in load method violate single responsbility principle, I feel like this is the trade off given that our project doesn't need that much complexity and the risk of tightly coupled dependencies. We can change it to another class just for filter in the future, just to make sure that it conform to another protocol so that we could use dependency inversion technique.
public class DetailedDataLoader: DetailedLoader {
    private let store: DetailRetrievalStore
    
    public init(store: DetailRetrievalStore) {
        self.store = store
    }
    
    public func loadDetailed(with predicate: NSPredicate?, completion: @escaping (LoadDetailedResult) -> Void) {
        store.retrieve(predicate: predicate) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(detailsDTO):
                completion(.success(detailsDTO.toModels() ))
            }
        }
    }
}

extension Array where Element == DetailedDTO {
    func toModels() -> [Detailed] {
        map { $0.toDomain() }
    }
}
