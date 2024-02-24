//
//  DetailRetrievalStore.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/24.
//

import Foundation

/// Blueprint for future implementation. Can used by different framework without coupling implenmentation details with Domain Details.
public protocol DetailRetrievalStore {
    func retrieve(predicate: NSPredicate?, completion: @escaping (RetrievalResult) -> Void)
}

public enum RetrievalResult {
    case empty
    case found([DetailedDTO])
    case failure(Error)
}
