//
//  DetailedUpdatedTests.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/25.
//

import XCTest
import GYMHack

public protocol DetailedUpdater {
    func updateDetailed(_ detail: Detailed, completion: @escaping (Error?) -> Void)
}

public protocol DetailUpdateStore {
    typealias UpdateDetailedDTOCompletion = (Error?) -> Void
    func update(detail: DetailedDTO, completion: @escaping UpdateDetailedDTOCompletion)
}

class DetailedDataUpdater: DetailedUpdater {
    private let store: DetailedDTOStoreSpy
    
    init(store: DetailedDTOStoreSpy) {
        self.store = store
    }
    
    func updateDetailed(_ detail: Detailed, completion: @escaping (Error?) -> Void) {
        store.update(detail: detail.toLocal()) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
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
    
    func test_updateDetailed_hasNoSideEffectsOnUpdateError() {
        let (sut, store) = makeSUT()
        let updateError = anyNSError()
        let anyDetail = anyDetail()
        
        sut.updateDetailed(anyDetail.model) { _ in }
        store.completeUpdate(with: updateError)
        
        XCTAssertEqual(store.receivedMessage, [.update(anyDetail.local.id)])
    }
    
    func test_updateDetailed_doesNotDeliverResultAfterSUTInstanceHasBeenDeallcoated() {
        let store = DetailedDTOStoreSpy()
        var sut: DetailedDataUpdater? = DetailedDataUpdater(store: store)
        var receivedResult = [Error?]()
        
        sut?.updateDetailed(anyDetail().model) {
            receivedResult.append($0)
        }
        
        sut = nil
        store.completeUpdate(with: anyNSError())
        
        XCTAssertTrue(receivedResult.isEmpty)
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
