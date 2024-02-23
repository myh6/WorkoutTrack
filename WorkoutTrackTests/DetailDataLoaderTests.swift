//
//  DataFetcherTests.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/16.
//

import XCTest
import GYMHack

class DetailDataLoader {
    private let store: DetailFeedStoreSpy
    
    init(store: DetailFeedStoreSpy) {
        self.store = store
    }
    
    func load(completion: @escaping ([Detailed]?, Error?) -> Void) {
        store.retrieve { data, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            completion(data?.toModels(), nil)
        }
    }
}

extension Array where Element == DetailedDTO {
    func toModels() -> [Detailed] {
        map { $0.toDomain() }
    }
}

final class DetailDataLoaderTests: XCTestCase {

    func test_init_doesNotMessageStore() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessage.isEmpty)
    }
    
    func test_load_requestDataRetrieval() {
        let (sut, store) = makeSUT()
        
        sut.load { _, _ in }
        
        XCTAssertEqual(store.receivedMessage, [.retrieve])
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyError()
        
        let exp = expectation(description: "Wait for load completion")
        var capturedError: Error?
        sut.load { _, receivedError in
            capturedError = receivedError
            exp.fulfill()
        }
        store.completeRetrieval(with: retrievalError)
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(capturedError as? NSError, retrievalError)
    }
    
    func test_load_deliversNoDataOnEmptyDatabase() {
        let (sut, store) = makeSUT()
        
        let exp = expectation(description: "Wait for load completion")
        sut.load { data, error in
            XCTAssertTrue(data?.isEmpty ?? false)
            exp.fulfill()
        }
        
        store.completeRetrieval(with: [])
        wait(for: [exp], timeout: 1.0)
    }
    
    //MARK: - Helper
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: DetailDataLoader, store: DetailFeedStoreSpy) {
        let store = DetailFeedStoreSpy()
        let sut = DetailDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func anyError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
}
