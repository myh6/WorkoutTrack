//
//  DetailedDeleter.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/3/16.
//

import Foundation

public protocol DetailedDeleter {
    typealias Result = Error?
    func delete(details: [Detailed], completion: @escaping (Result) -> Void)
}
