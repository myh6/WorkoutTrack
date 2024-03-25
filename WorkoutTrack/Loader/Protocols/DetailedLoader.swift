//
//  LoadResult.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/24.
//

import Foundation

public typealias LoadDetailedResult = Result<[Detailed], Error>

public protocol DetailedLoader {
    func loadDetailed(with predicate: NSPredicate?, completion: @escaping (LoadDetailedResult) -> Void)
}

public extension DetailedLoader {
    func loadDetailed(completion: @escaping (LoadDetailedResult) -> Void) {
        loadDetailed(with: nil, completion: completion)
    }
}
