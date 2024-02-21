//
//  DataFetcherTests.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/16.
//

import XCTest
import GYMHack

class DetailDataFetcher {
    
}

final class DetailDataFetcherTests: XCTestCase {

    func test_init_doesNotMessageStore() {
        let sut = DetailDataFetcher()
        let store = DetailFeedStoreSpy()
        
        XCTAssertTrue(store.receivedMessage.isEmpty)
    }
    
    //MARK: - Helper
    
    class DetailFeedStoreSpy: DetailAdditionStore {
        private var addDetailCompletion = [AddDataCompletion]()
        
        func addData(details: [DetailedDTO], completion: @escaping (Error?) -> Void) {
            receivedMessage.append(.addData(details))
            addDetailCompletion.append(completion)
        }
        
        func completeAddDetailSuccessfully(at index: Int = 0) {
            addDetailCompletion[index](nil)
        }
        
        func completeAddDetail(with error: NSError, at index: Int = 0) {
            addDetailCompletion[index](error)
        }
        
        enum ReceiveMessage: Equatable {
            case addData([DetailedDTO])
        }
        
        var receivedMessage = [ReceiveMessage]()
    }

}
