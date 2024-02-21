//
//  DataCreationTests.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/1.
//

import XCTest
import GYMHack
import CoreData
import UIKit

final class DetailFeedSaverTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessage.isEmpty)
    }
    
    func test_saveDetail_callsOnAddDataOnStore() {
        let (sut, store) = makeSUT()
        let details = anyDetails().model
        
        sut.save(details: details) { _ in }
        store.completeAddDetailSuccessfully()
        
        XCTAssertEqual(store.receivedMessage, [.addData(details.toLocal())])
    }
    
    func test_saveDetail_failsOnAddingDataError() {
        let (sut, store) = makeSUT()
        let anyError = anyError()
        
        let exp = expectation(description: "Wait for completion")
        sut.save(details: anyDetails().model) { receivedError in
            XCTAssertEqual(receivedError as? NSError, anyError)
            exp.fulfill()
        }
        store.completeAddDetail(with: anyError)
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_saveDtail_doesNotDeliverErrorAfterSUTInstanceHasBeenDeallocated() {
        let store = DetailFeedStoreSpy()
        var sut: DetailDataSaver? = DetailDataSaver(store: store)
        
        var receivedResult = [DetailDataSaver.SaveDetailResult]()
        sut?.save(details: anyDetails().model) { receivedResult.append($0) }
        
        sut = nil
        store.completeAddDetail(with: anyError())
        
        XCTAssertTrue(receivedResult.isEmpty)
    }
    
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: DetailDataSaver, store: DetailFeedStoreSpy) {
        let store = DetailFeedStoreSpy()
        let sut = DetailDataSaver(store: store)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        return (sut, store)
    }
    
    private func anyDetail() -> Detailed {
        let model = Detailed(uid: UUID(), setName: "any set", weight: 10, isDone: true, reps: 10, id: "any id")
        return (model)
    }
    
    private func anyDetails() -> (model: [Detailed], local: [DetailedDTO]) {
        let model = [anyDetail(), anyDetail(), anyDetail()]
        return (model, model.toLocal())
    }
    
    private func anyError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
    
    class DetailFeedStoreSpy: DetailAdditionStore {
        private var addDetailCompletion = [AddDataCompletion]()
        
        func addData(details: [DetailedDTO], completion: @escaping (Error?) -> Void) {
            receivedMessage.append(.addData(details))
            addDetailCompletion.append(completion)
        }
        
        func completeAddDetailSuccessfully(at index: Int = 0) {
            addDetailCompletion[index](nil)
        }
        
        func completeAddDetail(with error: NSError, at index: Int = 0) {
            addDetailCompletion[index](error)
        }
        
        enum ReceiveMessage: Equatable {
            case addData([DetailedDTO])
        }
        
        var receivedMessage = [ReceiveMessage]()
    }
}
