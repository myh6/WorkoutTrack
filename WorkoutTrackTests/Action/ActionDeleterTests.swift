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
        let store = ActionFeedStoreSpy()
        _ = ActionDataDeleter(store: store)
        
        XCTAssertTrue(store.receivedMessage.isEmpty)
    }
    
    func test_deleteAction_callsOnRemovalOnStore() {
        let store = ActionFeedStoreSpy()
        let sut = ActionDataDeleter(store: store)
        let actionID = UUID()
        
        sut.delete(action: actionID)
        
        XCTAssertEqual(store.receivedMessage, [.removal(actionID)])
    }
}
