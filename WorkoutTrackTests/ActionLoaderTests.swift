//
//  ActionLoaderTests.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/24.
//

import XCTest
import GYMHack

class ActionLoader {
    private let store: ActionFeedStoreSpy
    
    init(store: ActionFeedStoreSpy) {
        self.store = store
    }
    
    func loadAction(with predicate: NSPredicate? = nil, completion: @escaping (String?, Error?) -> Void) {
        store.retrieve(predicate: predicate, completion: completion)
    }
}

final class ActionLoaderTests: XCTestCase {
    
    func test_init_doesNoMessageStore() {
        let (_ , store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessage.isEmpty)
    }
    
    func test_loadAction_requestActionDataRetrievalWithPredicate() {
        let (sut, store) = makeSUT()
        let anyFormat = "id == %@"
        let predicate = NSPredicate(format: anyFormat, "testing")
        sut.loadAction(with: predicate) { _, _ in }
        
        XCTAssertEqual(store.receivedMessage, [.retrieve(predicate)])
    }
    
    func test_loadAction_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()
        
        let exp = expectation(description: "Wait for load completion")
        sut.loadAction { _, receivedError in
            XCTAssertEqual(retrievalError, receivedError as? NSError)
            exp.fulfill()
        }
        
        store.completeRetrieval(with: retrievalError)
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_loadAction_deliversNoDataOnEmptyDatabase() {
        let (sut, store) = makeSUT()
        
        let exp = expectation(description: "Wait for load completion")
        sut.loadAction { receivedAction, _ in
            XCTAssertNil(receivedAction)
            exp.fulfill()
        }
        store.completeRetrievalWithEmptyData()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    //MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: ActionLoader, store: ActionFeedStoreSpy) {
        let store = ActionFeedStoreSpy()
        let sut = ActionLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
}
