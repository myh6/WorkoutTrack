//
//  DetailRetrievalStore.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/24.
//

import Foundation

public protocol DetailRetrievalStore {
    func retrieve(completion: @escaping (RetrievalResult) -> Void)
}

public enum RetrievalResult {
    case empty
    case found([DetailedDTO])
    case failure(Error)
}
