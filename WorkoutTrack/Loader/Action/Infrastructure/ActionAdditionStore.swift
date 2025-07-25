//
//  LocalActionFeedStore.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/2/5.
//

import Foundation

public protocol ActionAdditionStore {
    typealias Result = Swift.Result<Void, Error>
    
    func addAction(action: [ActionDTO], completion: @escaping (Result) -> Void)
}
