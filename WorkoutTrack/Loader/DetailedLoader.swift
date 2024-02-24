//
//  LoadResult.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/24.
//

import Foundation

public enum LoadResult {
    case success([Detailed])
    case failure(Error)
}

public protocol DetailedLoader {
    func load(with predicate: NSPredicate?, completion: @escaping (LoadResult) -> Void)
}

public extension DetailedLoader {
    func load(completion: @escaping (LoadResult) -> Void) {
        load(with: nil, completion: completion)
    }
}
