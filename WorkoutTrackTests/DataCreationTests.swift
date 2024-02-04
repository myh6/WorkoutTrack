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
}

class LocalFeedStore {
    private let contextProvider: ContextProviding
    private var addCompletion = [(Error?) -> Void]()
    
    init(contextProvider: ContextProviding = MockContextProvider()) {
        self.contextProvider = contextProvider
    }
    
    func addData(detail: Detailed, completion: @escaping (Error?) -> Void) {
        receivedMessage.append(detail)
        addCompletion.append(completion)
    }
    
    func completeAddSuccessfully(at index: Int = 0) {
        addCompletion[index](nil)
    }
    
    var receivedMessage = [Detailed]()
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
        let detail = Detailed(uid: UUID(), setName: "any set", weight: 10.0, isDone: true, reps: 10, id: "any id")
        
        sut.save(detail: detail) { _ in }
        store.completeAddSuccessfully()
        
        XCTAssertEqual(store.receivedMessage, [detail])
    }
    
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: LocalFeedStore) {
        let store = LocalFeedStore()
        let sut = LocalFeedLoader(store: store)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        return (sut, store)
    }
}
