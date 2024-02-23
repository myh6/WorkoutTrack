//
//  DataFetcherTests.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/16.
//

import XCTest
import GYMHack

enum LoadResult {
    case success([Detailed])
    case failure(Error)
}
class DetailDataLoader {
    private let store: DetailFeedStoreSpy
    
    init(store: DetailFeedStoreSpy) {
        self.store = store
    }
    
    func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
                
            case .empty:
                completion(.success([]))
            }
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
        
        sut.load { _ in }
        
        XCTAssertEqual(store.receivedMessage, [.retrieve])
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyError()
        
        let exp = expectation(description: "Wait for load completion")
        sut.load { receivedResult in
            if case let .failure(receivedError) = receivedResult {
                XCTAssertEqual(receivedError as NSError, retrievalError)
            } else {
                XCTFail("Expected to fails on retrieval error, got \(receivedResult) instead.")
            }
            exp.fulfill()
        }
        store.completeRetrieval(with: retrievalError)
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_load_deliversNoDataOnEmptyDatabase() {
        let (sut, store) = makeSUT()
        
        let exp = expectation(description: "Wait for load completion")
        sut.load { receivedResult in
            if case let .success(data) = receivedResult {
                XCTAssertTrue(data.isEmpty)
            } else {
                XCTFail("Expected to delivers no data from empty database, got \(receivedResult) instead.")
            }
            exp.fulfill()
        }
        
        store.completeRetrievalWithEmptyData()
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
