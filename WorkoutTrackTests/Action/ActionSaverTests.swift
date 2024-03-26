//
//  LocalActionFeedLoaderTests.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/5.
//

import XCTest
import GYMHack

final class ActionSaverTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessage.isEmpty)
    }
    
    func test_saveAction_callsOnAddActionOnStore() {
        let (sut, store) = makeSUT()
        let anyAction = anyAction()
        
        sut.save(action: anyAction.model) { _ in }
        store.completeAddActionSuccessfully()
        
        XCTAssertEqual(store.receivedMessage, [.addAction([anyAction.local])])
    }
    
    func test_saveAction_failsOnAddingError() {
        let (sut, store) = makeSUT()
        let anyError = anyNSError()
        let action = anyAction()
        
        let exp = expectation(description: "Wait for completion")
        sut.save(action: action.model) { receivedError in
            XCTAssertEqual(receivedError as? NSError, anyError)
            exp.fulfill()
        }
        store.completeAddAction(with: anyError)
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_saveAction_doesNotDeliverErrorAfterSUTInstanceHasBeenDeallcoaed() {
        let store = ActionFeedStoreSpy()
        var sut: ActionSaver? = ActionDataSaver(store: store)
        
        var receivedResult = [ActionSaver.Result]()
        sut?.save(action: anyAction().model) { receivedResult.append($0) }
        
        sut = nil
        store.completeAddAction(with: anyNSError())
        
        XCTAssertTrue(receivedResult.isEmpty)
    }
    
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: ActionSaver, store: ActionFeedStoreSpy) {
        let store = ActionFeedStoreSpy()
        let sut = ActionDataSaver(store: store)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        return (sut, store)
    }
}

