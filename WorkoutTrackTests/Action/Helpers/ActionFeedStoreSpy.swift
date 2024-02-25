//
//  ActionFeedStoreSpy.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/24.
//

import Foundation
import GYMHack

class ActionFeedStoreSpy: ActionFeedStore, ActionRetrievalStore {
    private var addActionCompletion = [AddActionCompletion]()
    private var retrievalCompletion = [RetrievalCompletion]()
    
    func addAction(actionName: String, ofType: String, completion: @escaping (Error?) -> Void) {
        receivedMessage.append(.addAction((actionName, ofType)))
        addActionCompletion.append(completion)
    }
    
    func retrieve(predicate: NSPredicate?, completion: @escaping (ActionRetrievalResult) -> Void) {
        receivedMessage.append(.retrieve(predicate))
        retrievalCompletion.append(completion)
    }
    
    func completeAddActionSuccessfully(at index: Int = 0) {
        addActionCompletion[index](nil)
    }
    
    func completeAddAction(with error: NSError, at index: Int = 0) {
        addActionCompletion[index](error)
    }
    
    func completeRetrieval(with error: NSError, at index: Int = 0) {
        retrievalCompletion[index](.failure(error))
    }
    
    func completeRetrievalWithEmptyData(at index: Int = 0) {
        retrievalCompletion[index](.empty)
    }
    
    func completeRetrievalWith(action: String, type: String, at index: Int = 0) {
        retrievalCompletion[index](.found(ActionRetrievalResult.ActionFeed(actionName: action, typeName: type)))
    }
    
    enum ReceiveMessage: Equatable {
        static func == (lhs: ActionFeedStoreSpy.ReceiveMessage, rhs: ActionFeedStoreSpy.ReceiveMessage) -> Bool {
            switch (lhs, rhs) {
            case let (.addAction((la, lt)), .addAction((ra, rt))):
                return la == ra && lt == rt
            case let (.retrieve(lp), .retrieve(rp)):
                return lp == rp
            default:
                return false
            }
        }
        
        case addAction((actionName, ofType))
        case retrieve(NSPredicate?)

        typealias actionName = String
        typealias ofType = String
    }
    
    var receivedMessage = [ReceiveMessage]()
}
