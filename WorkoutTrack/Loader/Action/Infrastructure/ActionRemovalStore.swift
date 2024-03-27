//
//  ActionRemovalStore.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/3/24.
//

import Foundation

public protocol ActionRemovalStore {
    typealias RemovalCompletion = (Error?) -> Void
    func remove(actionID: UUID, completion: @escaping RemovalCompletion)
}
