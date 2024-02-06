//
//  LocalActionFeedLoaderTests.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/5.
//

import XCTest
import GYMHack

final class LocalActionFeedSaverTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessage.isEmpty)
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
    
    func test_saveAction_doesNotDeliverErrorAfterSUTInstanceHasBeenDeallcoaed() {
        let store = LocalActionFeedStoreSpy()
        var sut: LocalActionFeedSaver? = LocalActionFeedSaver(store: store)
        
        var receivedResult = [LocalActionFeedSaver.SaveActionResult]()
        sut?.save(action: anyAction(), ofType: anyType()) { receivedResult.append($0) }
        
        sut = nil
        store.completeAddAction(with: anyError())
        
        XCTAssertTrue(receivedResult.isEmpty)
    }
    
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalActionFeedSaver, store: LocalActionFeedStoreSpy) {
        let store = LocalActionFeedStoreSpy()
        let sut = LocalActionFeedSaver(store: store)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        return (sut, store)
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
    
    class LocalActionFeedStoreSpy: LocalActionFeedStore {
        private var addActionCompletion = [AddActionCompletion]()
        
        func addAction(actionName: String, ofType: String, completion: @escaping (Error?) -> Void) {
            receivedMessage.append(.addAction((actionName, ofType)))
            addActionCompletion.append(completion)
        }
        
        func completeAddActionSuccessfully(at index: Int = 0) {
            addActionCompletion[index](nil)
        }
        
        func completeAddAction(with error: NSError, at index: Int = 0) {
            addActionCompletion[index](error)
        }
        
        enum ReceiveMessage: Equatable {
            static func == (lhs: LocalActionFeedSaverTests.LocalActionFeedStoreSpy.ReceiveMessage, rhs: LocalActionFeedSaverTests.LocalActionFeedStoreSpy.ReceiveMessage) -> Bool {
                switch (lhs, rhs) {
                case let (.addAction((la, lt)), .addAction((ra, rt))):
                    return la == ra && lt == rt
                }
            }
            
            case addAction((actionName, ofType))

            typealias actionName = String
            typealias ofType = String
        }
        
        var receivedMessage = [ReceiveMessage]()
    }
}

