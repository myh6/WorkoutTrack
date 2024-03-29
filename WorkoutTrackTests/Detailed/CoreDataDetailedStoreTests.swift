//
//  CoreDataDetailedStoreTests.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/3/28.
//

import XCTest
import GYMHack

final class CoreDataDetailedStoreTests: XCTestCase {
    
    func test_retrieve_deliversEmptyOnEmptyDatabase() {
        let sut = makeSUT()
        
        expect(sut, with: nil, toRetrieve: .success([]))
    }
    
    func test_retrieve_hasNoSideEffecsOnEmptyDatabase() {
        let sut = makeSUT()
        
        expect(sut, with: nil, toRetrieve: .success([]))
        expect(sut, with: nil, toRetrieve: .success([]))
    }
        
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CoreDataDetailedStore {
        let storeBundle = Bundle(for: CoreDataDetailedStore.self)
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataDetailedStore(storeURL: storeURL, bundle: storeBundle)
        trackForMemoryLeaks(sut)
        return sut
    }
    
    private func expect(_ sut: DetailRetrievalStore, with predicate: NSPredicate?, toRetrieve expectedResult: DetailRetrievalStore.Result, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for retrieval")
        
        sut.retrieve(predicate: predicate) { retrievalResult in
            switch (expectedResult, retrievalResult) {
            case let (.success(expectedAction), .success(retrievedAction)):
                XCTAssertEqual(expectedAction, retrievedAction, file: file, line: line)
            case (.failure, .failure):
                break
            default:
                XCTFail("Expected to complete retrieval with \(expectedResult), but got \(retrievalResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
}
