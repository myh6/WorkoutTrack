//
//  DataCreationTests.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/1.
//

import XCTest
import GYMHack

final class DetailedSaverTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessage.isEmpty)
    }
    
    func test_saveDetail_callsOnAddDataOnStore() {
        let (sut, store) = makeSUT()
        let details = anyDetails().model
        let actionID = UUID()
        
        sut.save(details: details, to: actionID) { _ in }
        store.completeAddDetailSuccessfully()
        
        XCTAssertEqual(store.receivedMessage, [.addData(details.toLocal(), toActionWithID: actionID)])
    }
    
    func test_saveDetail_failsOnAddingDataError() {
        let (sut, store) = makeSUT()
        let anyError = anyNSError()
        let actionID = UUID()
        
        let exp = expectation(description: "Wait for completion")
        sut.save(details: anyDetails().model, to: actionID) { result in
            switch result {
            case let .failure(receivedError):
                XCTAssertEqual(receivedError as NSError, anyError)
            default:
                break
            }
            exp.fulfill()
        }
        store.completeAddDetail(with: anyError)
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_saveDtail_doesNotDeliverErrorAfterSUTInstanceHasBeenDeallocated() {
        let store = DetailedDTOStoreSpy()
        var sut: DetailedSaver? = DetailedDataSaver(store: store)
        let actionID = UUID()
        
        var receivedResult = [DetailedSaver.Result]()
        sut?.save(details: anyDetails().model, to: actionID) { receivedResult.append($0) }
        
        sut = nil
        store.completeAddDetail(with: anyNSError())
        
        XCTAssertTrue(receivedResult.isEmpty)
    }
    
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: DetailedSaver, store: DetailedDTOStoreSpy) {
        let store = DetailedDTOStoreSpy()
        let sut = DetailedDataSaver(store: store)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        return (sut, store)
    }
}
