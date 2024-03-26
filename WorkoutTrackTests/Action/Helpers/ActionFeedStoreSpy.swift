//
//  ActionFeedStoreSpy.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/24.
//

import Foundation
import GYMHack

class ActionFeedStoreSpy: ActionAdditionStore, ActionRetrievalStore, ActionRemovalStore {
    private var addActionCompletion = [AddActionCompletion]()
    private var retrievalCompletion = [RetrievalCompletion]()
    private var removalCompletion = [RemovalCompletion]()
    
    func addAction(action: [ActionDTO], completion: @escaping (Error?) -> Void) {
        receivedMessage.append(.addAction(action))
        addActionCompletion.append(completion)
    }
    
    func retrieve(predicate: NSPredicate?, completion: @escaping (ActionRetrievalResult) -> Void) {
        receivedMessage.append(.retrieve(predicate))
        retrievalCompletion.append(completion)
    }
    
    func remove(actionID: UUID, completion: @escaping (Error?) -> Void) {
        removalCompletion.append(completion)
        receivedMessage.append(.removal(actionID))
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
        retrievalCompletion[index](.success([]))
    }
    
    func completeRetrievalWith(action: [ActionDTO], at index: Int = 0) {
        retrievalCompletion[index](.success(action))
    }
    
    func completeRemoval(with error: NSError, at index: Int = 0) {
        removalCompletion[index](error)
    }
    
    enum ReceiveMessage: Equatable {
        static func == (lhs: ActionFeedStoreSpy.ReceiveMessage, rhs: ActionFeedStoreSpy.ReceiveMessage) -> Bool {
            switch (lhs, rhs) {
            case let (.addAction(la), .addAction(ra)):
                return la == ra
            case let (.retrieve(lp), .retrieve(rp)):
                return lp == rp
            case let (.removal(lID), .removal(rID)):
                return lID == rID
            default:
                return false
            }
        }
        
        case addAction([ActionDTO])
        case retrieve(NSPredicate?)
        case removal(UUID)

        typealias actionName = String
        typealias ofType = String
    }
    
    var receivedMessage = [ReceiveMessage]()
}
