//
//  ActionLoaderTests.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/24.
//

import XCTest
import GYMHack

class ActionLoader {
    
}

final class ActionLoaderTests: XCTestCase {
    
    func test_init_doesNoMessageStore() {
        let sut = ActionLoader()
        let store = ActionFeedStoreSpy()
        
        XCTAssertTrue(store.receivedMessage.isEmpty)
    }
}
