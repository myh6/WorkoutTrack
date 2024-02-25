//
//  DetailFeedStoreSpy.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/21.
//

import XCTest
import GYMHack

class DetailedDTOStoreSpy: DetailAdditionStore, DetailRetrievalStore {
    private var addDetailCompletion = [AddDetailedDTOCompletion]()
    private var retrievalCompletion = [(RetrievalResult) -> Void]()
    
    func add(details: [DetailedDTO], completion: @escaping AddDetailedDTOCompletion) {
        receivedMessage.append(.addData(details))
        addDetailCompletion.append(completion)
    }
    
    func retrieve(predicate: NSPredicate?, completion: @escaping (RetrievalResult) -> Void) {
        receivedMessage.append(.retrieve(predicate))
        retrievalCompletion.append(completion)
    }
    
    func update(with id: String) {
        receivedMessage.append(.update(id))
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
    
    enum ReceiveMessage: Equatable {
        case addData([DetailedDTO])
        case retrieve(NSPredicate?)
        case update(String)
    }
    
    var receivedMessage = [ReceiveMessage]()
}
