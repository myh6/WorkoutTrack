//
//  LocalFeedStore.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/2/4.
//

// Should be the blueprint of all the CoreData implementation
public protocol LocalDetailFeedStore {
    typealias AddDataCompletion = (Error?) -> Void
    
    func addData(details: [DetailedDTO], completion: @escaping AddDataCompletion)
}
