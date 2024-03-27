//
//  DetailUpdateStore.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/3/1.
//

import Foundation

public protocol DetailUpdateStore {
    typealias UpdateDetailedDTOCompletion = (Error?) -> Void
    func update(detail: DetailedDTO, completion: @escaping UpdateDetailedDTOCompletion)
}
