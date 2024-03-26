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
        
        let exp = expectation(description: "Wait for retrieval")
        sut.retrieve(predicate: nil) { retrievedResult in
            switch retrievedResult {
            case let .success(retrievedAction):
                XCTAssertTrue(retrievedAction.isEmpty)
            default:
                XCTFail("Expected sut to retrieve empty on empty database, got \(retrievedResult) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp])
    }
    
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CoreDataActionStore {
        let storeBundle = Bundle(for: CoreDataActionStore.self)
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataActionStore(storeURL: storeURL, bundle: storeBundle)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
