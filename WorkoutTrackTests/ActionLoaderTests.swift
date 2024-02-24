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
    
    func loadAction(with predicate: NSPredicate?) {
        store.retrieve(predicate: predicate)
    }
}

final class ActionLoaderTests: XCTestCase {
    
    func test_init_doesNoMessageStore() {
        let store = ActionFeedStoreSpy()
        let _ = ActionLoader(store: store)
        
        XCTAssertTrue(store.receivedMessage.isEmpty)
    }
    
    func test_load_requestActionDataRetrievalWithPredicate() {
        let store = ActionFeedStoreSpy()
        let sut = ActionLoader(store: store)
        let anyFormat = "id == %@"
        let predicate = NSPredicate(format: anyFormat, "testing")
        sut.loadAction(with: predicate)
        
        XCTAssertEqual(store.receivedMessage, [.retrieve(predicate)])
    }
}
