//
//  DetailedSaver.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/24.
//

import Foundation

public protocol DetailedSaver {
    typealias Result = Error?
    func save(details: [Detailed], to action: UUID, completion: @escaping (Result) -> Void)
}
