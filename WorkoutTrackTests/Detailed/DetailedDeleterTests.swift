//
//  DetailedDeleterTests.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/3/1.
//

import XCTest

class DetailedDataDeleter {}

final class DetailedDeleterTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        _ = DetailedDataDeleter()
        let store = DetailedDTOStoreSpy()
        
        XCTAssertTrue(store.receivedMessage.isEmpty)
    }

}
