//
//  ActionRemovalStore.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/3/24.
//

import Foundation

public protocol ActionRemovalStore {
    typealias Result = Swift.Result<Void, Error>
    func remove(actionID: UUID, completion: @escaping (Result) -> Void)
}
