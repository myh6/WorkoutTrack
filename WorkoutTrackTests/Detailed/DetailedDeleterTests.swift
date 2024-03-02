//
//  DetailedDeleterTests.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/3/1.
//

import XCTest
import GYMHack

class DetailedDataDeleter {
    private let store: DetailedDTOStoreSpy
    
    init(store: DetailedDTOStoreSpy) {
        self.store = store
    }
    
    func delete(details: [Detailed], completion: @escaping (Error?) -> Void = { _ in }) {
        store.remove(details: details.toLocal(), completion: completion)
    }
}

final class DetailedDeleterTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let store = DetailedDTOStoreSpy()
        _ = DetailedDataDeleter(store: store)
        
        XCTAssertTrue(store.receivedMessage.isEmpty)
    }
    
    func test_deleteDetails_callsOnRemovalOnStore() {
        let store = DetailedDTOStoreSpy()
        let sut = DetailedDataDeleter(store: store)
        let details = anyDetails().model
        
        sut.delete(details: details)
        XCTAssertEqual(store.receivedMessage, [.remove(details.toLocal())])
    }
    
    func test_deleteDetails_failsOnRemovalError() {
        let store = DetailedDTOStoreSpy()
        let sut = DetailedDataDeleter(store: store)
        let removalError = anyNSError()
        
        let exp = expectation(description: "Wait for deletion")
        sut.delete(details: anyDetails().model) { receivedError in
            XCTAssertEqual(removalError, receivedError as? NSError)
            exp.fulfill()
        }
        
        store.completeRemoval(with: removalError)
        wait(for: [exp], timeout: 1.0)
    }

}
