//
//  DataFetcherTests.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/16.
//

import XCTest
import GYMHack

final class DetailedLoaderTests: XCTestCase {

    func test_init_doesNotMessageStore() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessage.isEmpty)
    }
    
    func test_loadDetailed_requestDataRetrievalWithPredicate() {
        let (sut, store) = makeSUT()
        let anyFormat = "id == %@"
        let predicate = NSPredicate(format: anyFormat, "testing")
        
        sut.loadDetailed(with: predicate) { _ in}
        
        XCTAssertEqual(store.receivedMessage, [.retrieve(predicate)])
    }
    
    func test_loadDetailed_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(retrievalError)) {
            store.completeRetrieval(with: retrievalError)
        }
    }
    
    func test_loadDetailed_deliversNoDataOnEmptyDatabase() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .success([])) {
            store.completeRetrievalWithEmptyData()
        }
    }
    
    func test_loadDetailed_deliversDataOnNonEmptyDatabase() {
        let (sut, store) = makeSUT()
        let details = anyDetails()
        
        expect(sut, toCompleteWith: .success(details.model)) {
            store.completeRetrieval(with: details.local)
        }
    }
    
    func test_loadDetailed_hasNoSideEffectsOnRetrievalError() {
        let (sut, store) = makeSUT()
        
        sut.loadDetailed { _ in }
        store.completeRetrieval(with: anyNSError())
        
        XCTAssertEqual(store.receivedMessage, [.retrieve(nil)])
    }
    
    func test_loadDetailed_hasNoSideEffectsOnEmptyDatabase() {
        let (sut, store) = makeSUT()
        
        sut.loadDetailed { _ in }
        store.completeRetrievalWithEmptyData()
        
        XCTAssertEqual(store.receivedMessage, [.retrieve(nil)])
    }
    
    func test_loadDetailed_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let store = DetailedDTOStoreSpy()
        var sut: DetailedLoader? = DetailedDataLoader(store: store)
        
        var receivedReuslt = [LoadDetailedResult]()
        sut?.loadDetailed { receivedReuslt.append($0) }
        
        sut = nil
        store.completeRetrievalWithEmptyData()
        
        XCTAssertTrue(receivedReuslt.isEmpty)
    }
    
    //MARK: - Helper
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: DetailedLoader, store: DetailedDTOStoreSpy) {
        let store = DetailedDTOStoreSpy()
        let sut = DetailedDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: DetailedLoader, toCompleteWith expectedResult: LoadDetailedResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for load completion")
        sut.loadDetailed { receivedResult in
            switch (expectedResult, receivedResult) {
            case let (.failure(expectedError), .failure(receivedError)):
                XCTAssertEqual(expectedError as NSError, receivedError as NSError, file: file, line: line)
            
            case let (.success(expectedData), .success(receivedData)):
                XCTAssertEqual(expectedData, receivedData, file: file, line: line)
                
            default:
                XCTFail("Expected to finish with \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
    }
}
