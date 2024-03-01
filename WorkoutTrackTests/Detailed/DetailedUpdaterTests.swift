//
//  DetailedUpdatedTests.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/25.
//

import XCTest

class DetailedDataUpdater {
    private let store: DetailedDTOStoreSpy
    
    init(store: DetailedDTOStoreSpy) {
        self.store = store
    }
    
    func updateDetailed(with id: String, completion: @escaping (Error?) -> Void) {
        store.update(with: id, completion: completion)
    }
}

final class DetailedUpdaterTests: XCTestCase {

    func test_init_doesNotMessageStore() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessage.isEmpty)
    }
    
    func test_updateDetailed_requestDataUpdateWithID() {
        let (sut, store) = makeSUT()
        let anyID = UUID().uuidString
        
        sut.updateDetailed(with: anyID) { _ in }
        
        XCTAssertEqual(store.receivedMessage, [.update(anyID)])
    }
    
    func test_updateDetailed_failsOnUpdateError() {
        let (sut, store) = makeSUT()
        let anyID = UUID().uuidString
        let updateError = anyNSError()
        
        let exp = expectation(description: "Wait for update completion")
        sut.updateDetailed(with: anyID) { receivedError in
            XCTAssertEqual(updateError, receivedError as? NSError)
            exp.fulfill()
        }
        
        store.completeUpdate(with: updateError)
        wait(for: [exp], timeout: 1.0)
    }
    
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: DetailedDataUpdater, store: DetailedDTOStoreSpy) {
        let store = DetailedDTOStoreSpy()
        let sut = DetailedDataUpdater(store: store)
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(store)
        return (sut, store)
    }
}
