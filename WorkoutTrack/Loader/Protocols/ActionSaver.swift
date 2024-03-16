//
//  ActionSaver.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/3/16.
//

import Foundation

public protocol ActionSaver {
    typealias SaveActionResult = Error?
    func save(action: String, ofType: String, completion: @escaping (SaveActionResult) -> Void)
}
