//
//  DetailFeedStoreSpy.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/21.
//

import XCTest
import GYMHack

class DetailedDTOStoreSpy: DetailAdditionStore, DetailRetrievalStore, DetailUpdateStore {
    private var addDetailCompletion = [AddDetailedDTOCompletion]()
    private var retrievalCompletion = [RetrievalCompletion]()
    private var updateCompletion = [UpdateDetailedDTOCompletion]()
    
    func add(details: [DetailedDTO], completion: @escaping AddDetailedDTOCompletion) {
        receivedMessage.append(.addData(details))
        addDetailCompletion.append(completion)
    }
    
    func retrieve(predicate: NSPredicate?, completion: @escaping RetrievalCompletion) {
        receivedMessage.append(.retrieve(predicate))
        retrievalCompletion.append(completion)
    }
    
    func update(detail: DetailedDTO, completion: @escaping UpdateDetailedDTOCompletion) {
        receivedMessage.append(.update(detail.id))
        updateCompletion.append(completion)
    }
    
    func remove(details: [DetailedDTO]) {
        receivedMessage.append(.remove(details))
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
        retrievalCompletion[index](.empty)
    }
    
    func completeRetrieval(with details: [DetailedDTO], at index: Int = 0) {
        retrievalCompletion[index](.found(details))
    }
    
    func completeUpdate(with error: NSError, at index: Int = 0) {
        updateCompletion[index](error)
    }
    
    enum ReceiveMessage: Equatable {
        case addData([DetailedDTO])
        case retrieve(NSPredicate?)
        case update(String)
        case remove([DetailedDTO])
    }
    
    var receivedMessage = [ReceiveMessage]()
}
