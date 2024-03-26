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
        let addingError = anyNSError()
        let action = anyAction()
        
        expect(sut, save: action.model, toCompleteWith: .failure(addingError)) {
            store.completeAddAction(with: addingError)
        }
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
    
    private func expect(_ sut: ActionSaver, save model: AddActionModel, toCompleteWith expectedResult: ActionSaver.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for completion")

        sut.save(action: model) { receivedResult in
            switch (expectedResult, receivedResult) {
            case (.success, .success):
                break
            case let (.failure(expectedError), .failure(receivedError)):
                XCTAssertEqual(expectedError as NSError, receivedError as NSError, file: file, line: line)
            default:
                XCTFail("Expected to complete with \(expectedResult), but got \(receivedResult) instead")
            }
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
    }
}

