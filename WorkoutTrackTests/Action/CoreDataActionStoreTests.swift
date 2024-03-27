//
//  CoreDataActionStoreTests.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/3/26.
//

import XCTest
import GYMHack

final class CoreDataActionStoreTests: XCTestCase {
    
    func test_retrieve_deliversEmptyOnEmptyDatabase() {
        let sut = makeSUT()
        
        expect(sut, with: nil, toRetrieve: .success([]))
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyDatabase() {
        let sut = makeSUT()
        
        expect(sut, with: nil, toRetrieve: .success([]))
        expect(sut, with: nil, toRetrieve: .success([]))
    }
    
    func test_retrieve_deliversFoundValueOnNonEmptyDatabase() {
        let sut = makeSUT()
        let action = anyAction()
        let expA = expectation(description: "Wait for addition completion")
        let expR = expectation(description: "Wait for retrieval completion")
        
        sut.addAction(action: [action.local]) { _ in
            expA.fulfill()
        }
        sut.retrieve(predicate: nil) { result in
            switch result {
            case let .success(receivedAction):
                XCTAssertEqual([action.local], receivedAction)
            default:
                XCTFail("Expected to retrieve saved action, got \(result) instead.")
            }
            expR.fulfill()
        }
        
        wait(for: [expA, expR], timeout: 1.0)
    }
    
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CoreDataActionStore {
        let storeBundle = Bundle(for: CoreDataActionStore.self)
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataActionStore(storeURL: storeURL, bundle: storeBundle)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func expect(_ sut: CoreDataActionStore, with predicate: NSPredicate?, toRetrieve expectedResult: ActionRetrievalStore.Result, file: StaticString = #file, line: UInt = #line) {
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
