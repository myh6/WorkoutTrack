//
//  DetailedUpdatedTests.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/25.
//

import XCTest
import GYMHack

class DetailedDataUpdater {
    private let store: DetailedDTOStoreSpy
    
    init(store: DetailedDTOStoreSpy) {
        self.store = store
    }
    
    func updateDetailed(_ detail: Detailed, completion: @escaping (Error?) -> Void) {
        store.update(detail: detail.toLocal(), completion: completion)
    }
}

final class DetailedUpdaterTests: XCTestCase {

    func test_init_doesNotMessageStore() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessage.isEmpty)
    }
    
    func test_updateDetailed_requestDataUpdateWithID() {
        let (sut, store) = makeSUT()
        let detail = anyDetail()
        
        sut.updateDetailed(detail.model) { _ in }
        
        XCTAssertEqual(store.receivedMessage, [.update(detail.local.id)])
    }
    
    func test_updateDetailed_failsOnUpdateError() {
        let (sut, store) = makeSUT()
        let detail = anyDetail()
        let updateError = anyNSError()
        
        let exp = expectation(description: "Wait for update completion")
        sut.updateDetailed(detail.model) { receivedError in
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
