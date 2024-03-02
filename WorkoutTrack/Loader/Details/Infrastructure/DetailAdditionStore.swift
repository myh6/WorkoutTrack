//
//  LocalFeedStore.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/2/4.
//

/// Blueprint for future implementation. Can used by different framework without coupling implenmentation details with Domain Details.
public protocol DetailAdditionStore {
    typealias AddDetailedDTOCompletion = (Error?) -> Void
    
    func add(details: [DetailedDTO], completion: @escaping AddDetailedDTOCompletion)
}
