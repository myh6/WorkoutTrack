//
//  DetailedSaver.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/24.
//

import Foundation

public protocol DetailedSaver {
    typealias SaveDetailResult = Error?
    func save(details: [Detailed], completion: @escaping (SaveDetailResult) -> Void)
}
