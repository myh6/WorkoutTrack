//
//  LocalFeedStore.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/2/4.
//

// Should be the blueprint of all the CoreData implementation
public protocol LocalFeedStore {
    typealias DetailCompletion = (Error?) -> Void
    typealias ActionCompletion = (Error?) -> Void
    
    func addData(details: [DetailedDTO], completion: @escaping DetailCompletion)
    func addAction(actionName: String, ofType: String, completion: @escaping ActionCompletion)
}
