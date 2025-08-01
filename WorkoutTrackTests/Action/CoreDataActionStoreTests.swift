//
//  CoreDataActionStoreTests.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/3/26.
//

import XCTest
import GYMHack

final class CoreDataActionStoreTests: XCTestCase {
    
    func test_retrieve_deliversEmptyOnEmptyDatabase() {
        let sut = makeSUT()
        
        expect(sut, with: nil, toRetrieve: .success([]))
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyDatabase() {
        let sut = makeSUT()
        
        expect(sut, with: nil, toRetrieve: .success([]))
        expect(sut, with: nil, toRetrieve: .success([]))
    }
    
    func test_retrieve_deliversFoundValueOnNonEmptyDatabase() {
        let sut = makeSUT()
        let action = anyAction()
        
        addAction([action.local], to: sut)
        
        expect(sut, with: nil, toRetrieve: .success([action.local]))
    }
    
    func test_retrieve_deliversValuesMatchingPredicateOnIsOpen() {
        let sut = makeSUT()
        let openAction = anyAction(isOpen: true)
        let closedAction = anyAction(isOpen: false)
        let predicate = NSPredicate(format: "isOpen == YES")
        
        addAction([openAction.local, closedAction.local], to: sut)
        
        expect(sut, with: predicate, toRetrieve: .success([openAction.local]))
    }
    
    func test_retrieve_deliversValuesMatchingPredicateOnType() {
        let sut = makeSUT()
        let action1 = anyAction(type: "Type1")
        let action2 = anyAction(type: "Type2")
        let predicate = NSPredicate(format: "ofType == %@", "Type1")
        
        addAction([action1.local, action2.local], to: sut)
        
        expect(sut, with: predicate, toRetrieve: .success([action1.local]))
    }
    
    func test_retrieve_deliversValueMatchingPredicateOnCompoundPredicate() {
        let sut = makeSUT()
        let action1 = anyAction(type: "Type1", isOpen: false)
        let action2 = anyAction(type: "Type2", isOpen: true)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "isOpen == NO"),
            NSPredicate(format: "ofType == %@", "Type1")
        ])
        addAction([action1.local, action2.local], to: sut)
        
        expect(sut, with: compoundPredicate, toRetrieve: .success([action1.local]))
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyDatabase() {
        let sut = makeSUT()
        let action = anyAction()
        addAction([action.local], to: sut)
        
        expect(sut, with: nil, toRetrieveTwice: .success([action.local]))
    }
    
    func test_addAction_deliversNoErrorOnEmptyDatabase() {
        let sut = makeSUT()
        
        let addingOperationError = addAction([anyAction().local], to: sut)
        
        XCTAssertNil(addingOperationError)
    }
    
    func test_addAction_deliversNoErrorOnNonEmptyDatabase() {
        let sut = makeSUT()
        
        addAction([anyAction().local], to: sut)
        
        let addingOperationError = addAction([anyAction().local], to: sut)
        
        XCTAssertNil(addingOperationError)
    }
    
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CoreDataActionStore {
        let storeBundle = Bundle(for: CoreDataActionStore.self)
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataActionStore(storeURL: storeURL, bundle: storeBundle)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    @discardableResult
    private func addAction(_ local: [ActionDTO], to sut: CoreDataActionStore) -> Error? {
        let exp = expectation(description: "Wait for insertion")
        var insertionError: Error?
        sut.addAction(action: local) { result in
            if case let Result.failure(error) = result {
                insertionError = error
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        return insertionError
    }
    
    private func expect(_ sut: CoreDataActionStore, with predicate: NSPredicate?, toRetrieve expectedResult: ActionRetrievalStore.Result, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for retrieval")
        
        sut.retrieve(predicate: predicate) { retrievalResult in
            switch (expectedResult, retrievalResult) {
            case let (.success(expectedAction), .success(retrievedAction)):
                XCTAssertEqual(expectedAction, retrievedAction, file: file, line: line)
            case (.failure, .failure):
                break
            default:
                XCTFail("Expected to complete retrieval with \(expectedResult), but got \(retrievalResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func expect(_ sut: CoreDataActionStore, with predicate: NSPredicate?, toRetrieveTwice expectedResult: ActionRetrievalStore.Result, file: StaticString = #file, line: UInt = #line) {
        expect(sut, with: predicate, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, with: predicate, toRetrieve: expectedResult, file: file, line: line)
    }
}
