//
//  DetailFeedStoreSpy.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/21.
//

import XCTest
import GYMHack

class DetailFeedStoreSpy: DetailAdditionStore, DetailLoaderStore {
    private var addDetailCompletion = [AddDataCompletion]()
    
    func addData(details: [DetailedDTO], completion: @escaping (Error?) -> Void) {
        receivedMessage.append(.addData(details))
        addDetailCompletion.append(completion)
    }
    
    func retrieve() {
        receivedMessage.append(.retrieve)
    }
    
    func completeAddDetailSuccessfully(at index: Int = 0) {
        addDetailCompletion[index](nil)
    }
    
    func completeAddDetail(with error: NSError, at index: Int = 0) {
        addDetailCompletion[index](error)
    }
    
    enum ReceiveMessage: Equatable {
        case addData([DetailedDTO])
        case retrieve
    }
    
    var receivedMessage = [ReceiveMessage]()
}
