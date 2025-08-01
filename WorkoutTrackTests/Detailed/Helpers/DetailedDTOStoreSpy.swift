//
//  DetailFeedStoreSpy.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/21.
//

import XCTest
import GYMHack

class DetailedDTOStoreSpy: DetailAdditionStore, DetailRetrievalStore, DetailUpdateStore, DetailRemovalStore {
    private var addDetailCompletion = [AddDetailedDTOCompletion]()
    private var retrievalCompletion = [RetrievalDetailedDTOCompletion]()
    private var updateCompletion = [UpdateDetailedDTOCompletion]()
    private var removalCompletion = [RemovalDetailedDTOCompletion]()
    
    func add(details: [DetailedDTO], toActionWithID actionID: UUID, completion: @escaping AddDetailedDTOCompletion) {
        receivedMessage.append(.addData(details, toActionWithID: actionID))
        addDetailCompletion.append(completion)
    }
    
    func retrieve(predicate: NSPredicate?, completion: @escaping RetrievalDetailedDTOCompletion) {
        receivedMessage.append(.retrieve(predicate))
        retrievalCompletion.append(completion)
    }
    
    func update(detail: DetailedDTO, completion: @escaping UpdateDetailedDTOCompletion) {
        receivedMessage.append(.update(detail.uuid.uuidString))
        updateCompletion.append(completion)
    }
    
    func remove(details: [DetailedDTO], completion: @escaping RemovalDetailedDTOCompletion) {
        receivedMessage.append(.remove(details))
        removalCompletion.append(completion)
    }
    
    func completeAddDetailSuccessfully(at index: Int = 0) {
        addDetailCompletion[index](nil)
    }
    
    func completeAddDetail(with error: NSError, at index: Int = 0) {
        addDetailCompletion[index](error)
    }
    
    func completeRetrieval(with error: NSError, at index: Int = 0) {
        retrievalCompletion[index](.failure(error))
    }
    
    func completeRetrievalWithEmptyData(at index: Int = 0) {
        retrievalCompletion[index](.success(.none))
    }
    
    func completeRetrieval(with details: [DetailedDTO], at index: Int = 0) {
        retrievalCompletion[index](.success(details))
    }
    
    func completeUpdate(with error: NSError, at index: Int = 0) {
        updateCompletion[index](error)
    }
    
    func completeRemoval(with error: NSError, at index: Int = 0) {
        removalCompletion[index](error)
    }
    
    enum ReceiveMessage: Equatable {
        case addData([DetailedDTO], toActionWithID: UUID)
        case retrieve(NSPredicate?)
        case update(String)
        case remove([DetailedDTO])
    }
    
    var receivedMessage = [ReceiveMessage]()
}
