//
//  DetailedDeleterTests.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/3/1.
//

import XCTest
import GYMHack

final class DetailedDeleterTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessage.isEmpty)
    }
    
    func test_deleteDetails_callsOnRemovalOnStore() {
        let (sut, store) = makeSUT()
        let details = anyDetails().model
        
        sut.delete(details: details) { _ in }
        XCTAssertEqual(store.receivedMessage, [.remove(details.toLocal())])
    }
    
    func test_deleteDetails_failsOnRemovalError() {
        let (sut, store) = makeSUT()
        let removalError = anyNSError()
        
        expect(sut, remove: anyDetails().model, toCompleteWith: .failure(removalError)) {
            store.completeRemoval(with: removalError)
        }
    }
    
    func test_deleteDetails_hasNoSideEffectsOnRemovalError() {
        let (sut, store) = makeSUT()
        let details = anyDetails()
        let removalError = anyNSError()
        
        sut.delete(details: details.model) { _ in }
        store.completeRemoval(with: removalError)
        
        XCTAssertEqual(store.receivedMessage, [.remove(details.local)])
    }
    
    func test_deleteDetails_doesNotDeliversErrorAfterSUTInstanceHasBeenDeallocated() {
        let store = DetailedDTOStoreSpy()
        var sut: DetailedDeleter? = DetailedDataDeleter(store: store)
        var receivedResult = [DetailedDeleter.Result]()
        sut?.delete(details: anyDetails().model) { receivedResult.append($0) }
        
        sut = nil
        store.completeRemoval(with: anyNSError())
        
        XCTAssertTrue(receivedResult.isEmpty)
    }
    
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: DetailedDeleter, store: DetailedDTOStoreSpy) {
        let store = DetailedDTOStoreSpy()
        let sut = DetailedDataDeleter(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: DetailedDeleter, remove details: [Detailed], toCompleteWith expectedResult: DetailedDeleter.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for delete completion")
        
        sut.delete(details: details) { receivedResult in
            switch (receivedResult, expectedResult) {
            case (.success, .success):
                break
            
            case let (.failure(receivedError), .failure(expectedError)):
                XCTAssertEqual(receivedError as NSError, expectedError as NSError, file: file, line: line)
                
            default:
                XCTFail("Expected to completed with \(expectedResult), but got \(receivedResult) instead.", file: file, line: line)
            }
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
    }

}
