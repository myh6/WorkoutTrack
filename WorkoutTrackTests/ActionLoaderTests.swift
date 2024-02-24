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
    
    func loadAction(with predicate: NSPredicate? = nil, completion: @escaping (ActionRetrievalResult) -> Void) {
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
        sut.loadAction(with: predicate) { _ in }
        
        XCTAssertEqual(store.receivedMessage, [.retrieve(predicate)])
    }
    
    func test_loadAction_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(retrievalError)) {
            store.completeRetrieval(with: retrievalError)
        }
    }
    
    func test_loadAction_deliversNoDataOnEmptyDatabase() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .empty) {
            store.completeRetrievalWithEmptyData()
        }
    }
    
    func test_loadAction_deliversDataOnNonEmptyDatabase() {
        let (sut, store) = makeSUT()
        let action = anyAction()
        let type = anyType()
        let actionFeed = ActionRetrievalResult.ActionFeed(actionName: action, typeName: type)
        
        expect(sut, toCompleteWith: .found(actionFeed)) {
            store.completeRetrievalWith(action: action, type: type)
        }
    }
    
    func test_loadAction_hasNoSideEffectsOnRetrievalError() {
        let (sut, store) = makeSUT()
        
        sut.loadAction { _ in }
        store.completeRetrieval(with: anyNSError())
        
        XCTAssertEqual(store.receivedMessage, [.retrieve(nil)])
    }
    
    func test_loadAction_hasNoSideEffectOnEmptyDatabase() {
        let (sut, store) = makeSUT()
        
        sut.loadAction { _ in }
        store.completeRetrievalWithEmptyData()
        
        XCTAssertEqual(store.receivedMessage, [.retrieve(nil)])
    }
    
    //MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: ActionLoader, store: ActionFeedStoreSpy) {
        let store = ActionFeedStoreSpy()
        let sut = ActionLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: ActionLoader, toCompleteWith expectedResult: ActionRetrievalResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for load completion")
        sut.loadAction { receivedResult in
            switch (expectedResult, receivedResult) {
            case let (.failure(expectedError), .failure(receivedError)):
                XCTAssertEqual(expectedError as NSError, receivedError as NSError)
            case (.empty, .empty):
                break
            
            case let (.found(expectedAction), .found(receivedAction)):
                XCTAssertEqual(expectedAction, receivedAction)
            default:
                XCTFail("Expected to get \(expectedResult), got \(receivedResult) instead.")
            }
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
    }
    
    private func anyAction() -> String {
        return "any Action"
    }
    
    private func anyType() -> String {
        return "any type"
    }
}
