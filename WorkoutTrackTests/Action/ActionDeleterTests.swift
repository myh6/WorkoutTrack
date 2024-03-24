//
//  ActionDeleterTests.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/3/16.
//

import XCTest

class ActionDataDeleter {
    
    private let store: ActionFeedStoreSpy
    
    init(store: ActionFeedStoreSpy) {
        self.store = store
    }
    
    func delete(action: UUID, completion: @escaping (Error?) -> Void) {
        store.remove(actionID: action, completion: completion)
    }
}

final class ActionDeleterTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessage.isEmpty)
    }
    
    func test_deleteAction_callsOnRemovalOnStore() {
        let (sut, store) = makeSUT()
        let actionID = UUID()
        
        sut.delete(action: actionID) { _ in }
        
        XCTAssertEqual(store.receivedMessage, [.removal(actionID)])
    }
    
    func test_deleteAction_failsOnRemovalError() {
        let (sut, store) = makeSUT()
        let removalError = anyNSError()
        
        let exp = expectation(description: "Wait for deletion completion")
        sut.delete(action: anyActionID()) { receivedError in
            XCTAssertEqual(removalError, receivedError as? NSError)
            exp.fulfill()
        }
        store.completeRemoval(with: removalError)
        
        wait(for: [exp])
    }
    
    func test_deleteAction_hasNoSideEffectsOnRemovalError() {
        let (sut, store) = makeSUT()
        let removalError = anyNSError()
        let actionID = anyActionID()
        
        sut.delete(action: actionID) { _ in }
        store.completeRemoval(with: removalError)
        
        XCTAssertEqual(store.receivedMessage, [.removal(actionID)])
    }
    
    
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: ActionDataDeleter, store: ActionFeedStoreSpy) {
        let store = ActionFeedStoreSpy()
        let sut = ActionDataDeleter(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func anyActionID() -> UUID {
        return UUID()
    }
}
