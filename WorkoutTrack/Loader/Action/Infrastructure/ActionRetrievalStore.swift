//
//  ActionRetrievalStore.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/25.
//

import Foundation

public protocol ActionRetrievalStore {
    typealias RetrievalCompletion = (ActionRetrievalResult) -> Void

    func retrieve(predicate: NSPredicate?, completion: @escaping RetrievalCompletion)
}
