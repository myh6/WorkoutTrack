//
//  LocalActionFeedStore.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/2/5.
//

import Foundation

public protocol ActionAdditionStore {
    typealias AddActionCompletion = (Result<Void, Error>) -> Void
    
    func addAction(action: [ActionDTO], completion: @escaping AddActionCompletion)
}
