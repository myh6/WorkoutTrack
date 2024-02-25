//
//  LocalActionFeedStore.swift
//  GYMHack
//
//  Created by Min-Yang Huang on 2024/2/5.
//

import Foundation

public protocol ActionAdditionStore {
    typealias AddActionCompletion = (Error?) -> Void
    
    func addAction(actionName: String, ofType: String, completion: @escaping AddActionCompletion)
}
