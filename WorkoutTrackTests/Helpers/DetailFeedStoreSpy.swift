//
//  DetailFeedStoreSpy.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/21.
//

import XCTest
import GYMHack

class DetailFeedStoreSpy: DetailAdditionStore, DetailRetrievalStore {
    private var addDetailCompletion = [AddDataCompletion]()
    private var retrievalCompletion = [(RetrievalResult) -> Void]()
    
    func addData(details: [DetailedDTO], completion: @escaping AddDataCompletion) {
        receivedMessage.append(.addData(details))
        addDetailCompletion.append(completion)
    }
    
    func retrieve(completion: @escaping (RetrievalResult) -> Void) {
        receivedMessage.append(.retrieve)
        retrievalCompletion.append(completion)
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
        case retrieve
    }
    
    var receivedMessage = [ReceiveMessage]()
}
