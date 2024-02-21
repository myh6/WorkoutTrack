//
//  DataFetcherTests.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/16.
//

import XCTest
import GYMHack

class DetailDataFetcher {
    private let store: DetailFeedStoreSpy
    
    init(store: DetailFeedStoreSpy) {
        self.store = store
    }
    
    func load(completion: @escaping (Error?) -> Void) {
        store.retrieve { error in
            completion(error)
        }
    }
}

final class DetailDataFetcherTests: XCTestCase {

    func test_init_doesNotMessageStore() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessage.isEmpty)
    }
    
    func test_load_requestDataRetrieval() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        
        XCTAssertEqual(store.receivedMessage, [.retrieve])
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyError()
        
        let exp = expectation(description: "Wait for load completion")
        var capturedError: Error?
        sut.load { receivedError in
            capturedError = receivedError
            exp.fulfill()
        }
        store.completeRetrieval(with: retrievalError)
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(capturedError as? NSError, retrievalError)
    }
    
    //MARK: - Helper
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: DetailDataFetcher, store: DetailFeedStoreSpy) {
        let store = DetailFeedStoreSpy()
        let sut = DetailDataFetcher(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func anyError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
}
