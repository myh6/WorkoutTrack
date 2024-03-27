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
        
        insert([action.local], to: sut)
        
        expect(sut, with: nil, toRetrieve: .success([action.local]))
    }
    
    func test_retrieve_deliversValuesMatchingPredicateOnIsOpen() {
        let sut = makeSUT()
        let openAction = anyAction(isOpen: true)
        let closedAction = anyAction(isOpen: false)
        let predicate = NSPredicate(format: "isOpen == YES")
        
        insert([openAction.local, closedAction.local], to: sut)
        
        expect(sut, with: predicate, toRetrieve: .success([openAction.local]))
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyDatabase() {
        let sut = makeSUT()
        let action = anyAction()
        insert([action.local], to: sut)
        
        expect(sut, with: nil, toRetrieveTwice: .success([action.local]))
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
    private func insert(_ local: [ActionDTO], to sut: CoreDataActionStore) -> Error? {
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
