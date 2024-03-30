//
//  CoreDataActionStoreTests.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/3/26.
//

import XCTest
import GYMHack

final class CoreDataStoreTests: XCTestCase {
    
    func test_retrieveAction_deliversEmptyOnEmptyDatabase() {
        let sut: ActionStore = makeSUT()
        
        expect(sut, with: nil, toRetrieve: .success([]))
    }
    
    func test_retrieveDetail_deliversEmptyOnEmptyDatabase() {
        let sut: DetailRetrievalStore = makeSUT()
        
        expect(sut, with: nil, toRetrieve: .success([]))
    }
    
    func test_retrieveAction_hasNoSideEffectsOnEmptyDatabase() {
        let sut: ActionStore = makeSUT()
        
        expect(sut, with: nil, toRetrieveTwice: .success([]))
    }
    
    func test_retrieveDetail_hasNoSideEffectsOnEmptyDatabase() {
        let sut: DetailRetrievalStore = makeSUT()
        
        expect(sut, with: nil, toRetrieveTwice: .success([]))
    }
    
    func test_retrieveAction_deliversFoundValueOnNonEmptyDatabase() {
        let sut = makeSUT()
        let action = anyAction()
        
        addActions([action.local], to: sut)
        
        expect(sut, with: nil, toRetrieve: .success([action.local]))
    }
    
    func test_retrieveDetail_deliversFoundValueOnNonEmptyDatabase() {
        let sut: ActionAdditionStore & DetailRetrievalStore = makeSUT()
        let action = anyAction()
        
        addActions([action.local], to: sut)
        
        expect(sut, with: nil, toRetrieve: .success(action.local.details))
    }
    
    func test_retrieveAction_deliversValuesMatchingPredicateOnID() {
        let sut = makeSUT()
        let id1 = UUID()
        let action1 = anyAction(id: id1)
        let action2 = anyAction(id: UUID())
        let predicate = NSPredicate(format: "id == %@", id1 as CVarArg)
        
        addActions([action1.local, action2.local], to: sut)
        
        expect(sut, with: predicate, toRetrieve: .success([action1.local]))
    }
    
    func test_retrieveDetail_deliversValuesMatchingPredicateOnID() {
        let sut: ActionAdditionStore & DetailRetrievalStore = makeSUT()
        let anyID = UUID()
        let detail = anyDetail(id: anyID)
        let predicate = NSPredicate(format: "id == %@", anyID as CVarArg)
        
        addActions([anyAction(details: [detail.local]).local], to: sut)
        
        expect(sut, with: predicate, toRetrieve: .success([detail.local]))
    }
    
    func test_retrieveAction_deliversValuesMatchingPredicateOnIsOpen() {
        let sut = makeSUT()
        let openAction = anyAction(isOpen: true)
        let closedAction = anyAction(isOpen: false)
        let predicate = NSPredicate(format: "isOpen == YES")
        
        addActions([openAction.local, closedAction.local], to: sut)
        
        expect(sut, with: predicate, toRetrieve: .success([openAction.local]))
    }
    
    func test_retrieveAction_deliversValuesMatchingPredicateOnType() {
        let sut = makeSUT()
        let action1 = anyAction(type: "Type1")
        let action2 = anyAction(type: "Type2")
        let predicate = NSPredicate(format: "ofType == %@", "Type1")
        
        addActions([action1.local, action2.local], to: sut)
        
        expect(sut, with: predicate, toRetrieve: .success([action1.local]))
    }
    
    func test_retrieveAction_deliversValueMatchingPredicateOnCompoundPredicate() {
        let sut = makeSUT()
        let action1 = anyAction(type: "Type1", isOpen: false)
        let action2 = anyAction(type: "Type2", isOpen: true)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "isOpen == NO"),
            NSPredicate(format: "ofType == %@", "Type1")
        ])
        addActions([action1.local, action2.local], to: sut)
        
        expect(sut, with: compoundPredicate, toRetrieve: .success([action1.local]))
    }
    
    func test_retrieveDetail_deliversValuesMatchingPredicateOnIsDone() {
        let sut: ActionAdditionStore & DetailRetrievalStore = makeSUT()
        let detail = anyDetail(isDone: true)
        let predicate = NSPredicate(format: "isDone == YES")
        
        addActions([anyAction(details: [detail.local]).local], to: sut)
        
        expect(sut, with: predicate, toRetrieve: .success([detail.local]))
    }
    
    func test_retrieveAction_hasNoSideEffectsOnNonEmptyDatabase() {
        let sut = makeSUT()
        let action = anyAction()
        addActions([action.local], to: sut)
        
        expect(sut, with: nil, toRetrieveTwice: .success([action.local]))
    }
    
    func test_addAction_deliversNoErrorOnEmptyDatabase() {
        let sut = makeSUT()
        
        let addingOperationError = addActions([anyAction().local], to: sut)
        
        XCTAssertNil(addingOperationError)
    }
    
    func test_addAction_deliversNoErrorOnNonEmptyDatabase() {
        let sut = makeSUT()
        
        addActions([anyAction().local], to: sut)
        
        let addingOperationError = addActions([anyAction().local], to: sut)
        
        XCTAssertNil(addingOperationError)
    }
    
    func test_removeAction_deliversNoErrorOnEmptyDatabase() {
        let sut = makeSUT()
        
        let deletionError = delete(id: UUID(), from: sut)
        XCTAssertNil(deletionError)
    }
    
    func test_removeAction_deliversNoErrorOnNonEmptyDatabase() {
        let sut = makeSUT()
        
        addActions([anyAction().local], to: sut)
        
        let deletionError = addActions([anyAction().local], to: sut)
        
        XCTAssertNil(deletionError)
    }
    
    func test_removeAction_deletesPreviouslyAddedDataWithMatchingID() {
        let sut: ActionStore = makeSUT()
        let id = UUID()
        let action = anyAction(id: id)
        
        addActions([action.local], to: sut)
        
        delete(id: id, from: sut)
        
        expect(sut, with: nil, toRetrieve: .success([]))
    }
    
    func test_storeSideEffects_runSerially() {
        let sut: ActionStore = makeSUT()
        
        var completedOperationInOrder = [XCTestExpectation]()
        
        let op1 = expectation(description: "Operation 1")
        sut.addAction(action: [anyAction().local]) { _ in
            completedOperationInOrder.append(op1)
            op1.fulfill()
        }
        
        let op2 = expectation(description: "Opeartion 2")
        sut.retrieve(predicate: nil) { _ in
            completedOperationInOrder.append(op2)
            op2.fulfill()
        }
        
        let op3 = expectation(description: "Operation 3")
        sut.remove(actionID: UUID()) { _ in
            completedOperationInOrder.append(op3)
            op3.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
        
        XCTAssertEqual(completedOperationInOrder, [op1, op2, op3], "Expected side-effects to run serially but operations finished in the wrong order: \(completedOperationInOrder)")
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
    private func addActions(_ local: [ActionDTO], to sut: ActionAdditionStore) -> Error? {
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
    
    @discardableResult
    private func delete(id: UUID, from sut: ActionRemovalStore, file: StaticString = #file, line: UInt = #line) -> Error? {
        let exp = expectation(description: "Wait for removal completion")
        var receivedError: Error?
        
        sut.remove(actionID: id) { result in
            if case let Result.failure(error) = result {
                receivedError = error
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return receivedError
    }
    
    private func expect(_ sut: ActionRetrievalStore, with predicate: NSPredicate?, toRetrieve expectedResult: ActionRetrievalStore.Result, file: StaticString = #file, line: UInt = #line) {
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
    
    private func expect(_ sut: ActionRetrievalStore, with predicate: NSPredicate?, toRetrieveTwice expectedResult: ActionRetrievalStore.Result, file: StaticString = #file, line: UInt = #line) {
        expect(sut, with: predicate, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, with: predicate, toRetrieve: expectedResult, file: file, line: line)
    }
    
    private func expect(_ sut: DetailRetrievalStore, with predicate: NSPredicate?, toRetrieveTwice expectedResult: DetailRetrievalStore.Result, file: StaticString = #file, line: UInt = #line) {
        expect(sut, with: predicate, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, with: predicate, toRetrieve: expectedResult, file: file, line: line)
    }
    
    private func expect(_ sut: DetailRetrievalStore, with predicate: NSPredicate?, toRetrieve expectedResult: DetailRetrievalStore.Result, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for retrieval")
        
        sut.retrieve(predicate: predicate) { retrievalResult in
            switch (expectedResult, retrievalResult) {
            case let (.success(expectedAction), .success(retrievedAction)):
                XCTAssertEqual(Set(expectedAction), Set(retrievedAction), file: file, line: line)
            case (.failure, .failure):
                break
            default:
                XCTFail("Expected to complete retrieval with \(expectedResult), but got \(retrievalResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}
