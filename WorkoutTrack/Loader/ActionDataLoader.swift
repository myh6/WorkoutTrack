//
//  ActionLoader.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/25.
//

import Foundation

public enum ActionRetrievalResult {
    public struct ActionFeed: Equatable {
        let actionName: String
        let typeName: String
        
        public init(actionName: String, typeName: String) {
            self.actionName = actionName
            self.typeName = typeName
        }
    }
    
    case empty
    case failure(Error)
    case found(ActionFeed)
}
