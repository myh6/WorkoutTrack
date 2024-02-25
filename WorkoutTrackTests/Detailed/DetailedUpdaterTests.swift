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
    
    func updateDetailed(with id: String) {
        store.update(with: id)
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
        
        sut.updateDetailed(with: anyID)
        
        XCTAssertEqual(store.receivedMessage, [.update(anyID)])
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
