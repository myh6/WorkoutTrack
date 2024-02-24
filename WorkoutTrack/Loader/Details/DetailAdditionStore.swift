//
//  LocalFeedStore.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/2/4.
//

/// Blueprint for future implementation. Can used by different framework without coupling implenmentation details with Domain Details.
public protocol DetailAdditionStore {
    typealias AddDataCompletion = (Error?) -> Void
    
    func addData(details: [DetailedDTO], completion: @escaping AddDataCompletion)
}
