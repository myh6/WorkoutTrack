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

class LocalFeedLoader {
    let store: LocalFeedStore
    
    init(store: LocalFeedStore) {
        self.store = store
    }
    
    func save(detail: Detailed, completion: @escaping (Error?) -> Void) {
        store.addData(detail: detail, completion: completion)
    }
    
    func save(action: String, ofType: String, completion: @escaping (Error?) -> Void) {
        store.addAction(actionName: action, ofType: ofType, completion: completion)
    }
}

class LocalFeedStore {
    private let contextProvider: ContextProviding
    private var addDetailCompletion = [(Error?) -> Void]()
    private var addActionCompletion = [(Error?) -> Void]()
    
    init(contextProvider: ContextProviding = MockContextProvider()) {
        self.contextProvider = contextProvider
    }
    
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
        static func == (lhs: LocalFeedStore.ReceiveMessage, rhs: LocalFeedStore.ReceiveMessage) -> Bool {
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

class MockContextProvider: ContextProviding {
    var context: NSManagedObjectContext {
        return MockContext()
    }
}

class MockContext: NSManagedObjectContext {}


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
        let anyError = NSError(domain: "any error", code: 0)
        
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
        let anyAction = "any action"
        let anyType = "any type"
        
        sut.save(action: anyAction, ofType: anyType) { _ in }
        store.completeAddActionSuccessfully()
        
        XCTAssertEqual(store.receivedMessage, [.addAction((anyAction, anyType))])
    }
    
    func test_saveAction_failsOnAddingError() {
        let (sut, store) = makeSUT()
        let anyError = NSError(domain: "any error", code: 0)
        let action = "any action"
        let type = "any type"
        
        let exp = expectation(description: "Wait for completion")
        sut.save(action: action, ofType: type) { receivedError in
            XCTAssertEqual(receivedError as? NSError, anyError)
            exp.fulfill()
        }
        store.completeAddAction(with: anyError)
        wait(for: [exp], timeout: 1.0)
    }
    
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: LocalFeedStore) {
        let store = LocalFeedStore()
        let sut = LocalFeedLoader(store: store)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        return (sut, store)
    }
    
    private func anyDetailed() -> Detailed {
        return Detailed(uid: UUID(), setName: "any set", weight: 10.0, isDone: true, reps: 0, id: "any id")
    }
}
