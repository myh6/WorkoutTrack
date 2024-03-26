//
//  ActionSaver.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/3/16.
//

import Foundation

public protocol ActionSaver {
    typealias Result = Error?
    func save(action: AddActionModel, completion: @escaping (Result) -> Void)
}
