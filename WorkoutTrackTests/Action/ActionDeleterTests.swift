//
//  ActionDeleterTests.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/3/16.
//

import XCTest

class ActionDataDeleter {}

final class ActionDeleterTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let sut = ActionDataDeleter()
        let store = ActionFeedStoreSpy()
        
        XCTAssertTrue(store.receivedMessage.isEmpty)
    }
}
