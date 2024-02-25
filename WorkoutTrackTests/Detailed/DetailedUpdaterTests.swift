//
//  DetailedUpdatedTests.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/25.
//

import XCTest

class DetailedDataUpdater {
    
}

final class DetailedUpdaterTests: XCTestCase {

    func test_init_doesNotMessageStore() {
        let store = DetailedDTOStoreSpy()
        let sut = DetailedDataUpdater()
        
        XCTAssertTrue(store.receivedMessage.isEmpty)
    }
}
