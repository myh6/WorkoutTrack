//
//  File.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/3/16.
//

import Foundation

public protocol DetailRemovalStore {
    typealias RemovalDetailedDTOCompletion = (Error?) -> Void
    
    func remove(details: [DetailedDTO], completion: @escaping RemovalDetailedDTOCompletion)
}
