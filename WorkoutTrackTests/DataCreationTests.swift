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

final class DataCreationTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessage.isEmpty)
    }
    
    func test_saveDetail_callsOnAddDataOnStore() {
        let (sut, store) = makeSUT()
        let detail = anyDetailed()
        
        sut.save(detail: detail) { _ in }
        store.completeAddDetailSuccessfully()
        
        XCTAssertEqual(store.receivedMessage, [.addData(detail)])
    }
    
    func test_saveDetail_failsOnAddingDataError() {
        let (sut, store) = makeSUT()
        let anyError = anyError()
        
        let exp = expectation(description: "Wait for completion")
        sut.save(detail: anyDetailed()) { receivedError in
            XCTAssertEqual(receivedError as? NSError, anyError)
            exp.fulfill()
        }
        store.completeAddDetail(with: anyError)
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_saveAction_callsOnAddActionOnStore() {
        let (sut, store) = makeSUT()
        let anyAction = anyAction()
        let anyType = anyType()
        
        sut.save(action: anyAction, ofType: anyType) { _ in }
        store.completeAddActionSuccessfully()
        
        XCTAssertEqual(store.receivedMessage, [.addAction((anyAction, anyType))])
    }
    
    func test_saveAction_failsOnAddingError() {
        let (sut, store) = makeSUT()
        let anyError = anyError()
        let action = anyAction()
        let type = anyType()
        
        let exp = expectation(description: "Wait for completion")
        sut.save(action: action, ofType: type) { receivedError in
            XCTAssertEqual(receivedError as? NSError, anyError)
            exp.fulfill()
        }
        store.completeAddAction(with: anyError)
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_saveDtail_doesNotDeliverErrorAfterSUTInstanceHasBeenDeallocated() {
        let store = LocalFeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store)
        
        var receivedResult = [LocalFeedLoader.DetailResult]()
        sut?.save(detail: anyDetailed()) { receivedResult.append($0) }
        
        sut = nil
        store.completeAddDetail(with: anyError())
        
        XCTAssertTrue(receivedResult.isEmpty)
    }
    
    func test_saveAction_doesNotDeliverErrorAfterSUTInstanceHasBeenDeallcoaed() {
        let store = LocalFeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store)
        
        var receivedResult = [LocalFeedLoader.ActionResult]()
        sut?.save(action: anyAction(), ofType: anyType()) { receivedResult.append($0) }
        
        sut = nil
        store.completeAddAction(with: anyError())
        
        XCTAssertTrue(receivedResult.isEmpty)
    }
    
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: LocalFeedStoreSpy) {
        let store = LocalFeedStoreSpy()
        let sut = LocalFeedLoader(store: store)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        return (sut, store)
    }
    
    private func anyDetailed() -> Detailed {
        return Detailed(uid: UUID(), setName: "any set", weight: 10.0, isDone: true, reps: 0, id: "any id")
    }
    
    private func anyError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
    
    private func anyAction() -> String {
        return "any Action"
    }
    
    private func anyType() -> String {
        return "any type"
    }
    
    class LocalFeedStoreSpy: LocalFeedStore {
        private var addDetailCompletion = [DetailCompletion]()
        private var addActionCompletion = [ActionCompletion]()
        
        func addData(detail: Detailed, completion: @escaping (Error?) -> Void) {
            receivedMessage.append(.addData(detail))
            addDetailCompletion.append(completion)
        }
        
        func addAction(actionName: String, ofType: String, completion: @escaping (Error?) -> Void) {
            receivedMessage.append(.addAction((actionName, ofType)))
            addActionCompletion.append(completion)
        }
        
        func completeAddDetailSuccessfully(at index: Int = 0) {
            addDetailCompletion[index](nil)
        }
        
        func completeAddActionSuccessfully(at index: Int = 0) {
            addActionCompletion[index](nil)
        }
        
        func completeAddDetail(with error: NSError, at index: Int = 0) {
            addDetailCompletion[index](error)
        }
        
        func completeAddAction(with error: NSError, at index: Int = 0) {
            addActionCompletion[index](error)
        }
        
        enum ReceiveMessage: Equatable {
            static func == (lhs: LocalFeedStoreSpy.ReceiveMessage, rhs: LocalFeedStoreSpy.ReceiveMessage) -> Bool {
                switch (lhs, rhs) {
                case let (addData(ldata), addData(rdata)):
                    return ldata == rdata
                case let (.addAction((la, lt)), .addAction((ra, rt))):
                    return la == ra && lt == rt
                default:
                    return false
                }
            }
            
            case addData(Detailed)
            case addAction((actionName, ofType))

            typealias actionName = String
            typealias ofType = String
        }
        
        var receivedMessage = [ReceiveMessage]()
    }
}
