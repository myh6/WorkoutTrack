//
//  ActionDeleter.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/3/24.
//

import Foundation

public protocol ActionDeleter {
    typealias Result = Error?
    func delete(action: UUID, completion: @escaping (Result) -> Void)
}
