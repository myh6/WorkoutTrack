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
    
    func delete(action: UUID) {
        store.remove(actionID: action)
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
        
        sut.delete(action: actionID)
        
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
}
