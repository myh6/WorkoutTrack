//
//  File.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/3/16.
//

import Foundation

public protocol DetailRemovalStore {
    typealias Result = Swift.Result<Void, Error>
    
    func remove(details: [DetailedDTO], completion: @escaping (Result) -> Void)
}
