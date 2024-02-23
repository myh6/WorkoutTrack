//
//  DataFetcherTests.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/16.
//

import XCTest
import GYMHack

enum LoadResult {
    case success([Detailed])
    case failure(Error)
}
class DetailDataLoader {
    private let store: DetailFeedStoreSpy
    
    init(store: DetailFeedStoreSpy) {
        self.store = store
    }
    
    func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
                
            case .empty:
                completion(.success([]))
                
            case let .found(detailsDTO):
                completion(.success(detailsDTO.toModels()))
            }
        }
    }
}

extension Array where Element == DetailedDTO {
    func toModels() -> [Detailed] {
        map { $0.toDomain() }
    }
}

final class DetailDataLoaderTests: XCTestCase {

    func test_init_doesNotMessageStore() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessage.isEmpty)
    }
    
    func test_load_requestDataRetrieval() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        
        XCTAssertEqual(store.receivedMessage, [.retrieve])
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyError()
        
        expect(sut, toCompleteWith: .failure(retrievalError)) {
            store.completeRetrieval(with: retrievalError)
        }
    }
    
    func test_load_deliversNoDataOnEmptyDatabase() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .success([])) {
            store.completeRetrievalWithEmptyData()
        }
    }
    
    func test_load_deliversDataOnNonEmptyDatabase() {
        let (sut, store) = makeSUT()
        let details = anyDetails()
        
        expect(sut, toCompleteWith: .success(details.model)) {
            store.completeRetrieval(with: details.local)
        }
    }
    
    func test_load_hasNoSideEffectsOnRetrievalError() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        store.completeRetrieval(with: anyError())
        
        XCTAssertEqual(store.receivedMessage, [.retrieve])
    }
    
    //MARK: - Helper
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: DetailDataLoader, store: DetailFeedStoreSpy) {
        let store = DetailFeedStoreSpy()
        let sut = DetailDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: DetailDataLoader, toCompleteWith expectedResult: LoadResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for load completion")
        sut.load { receivedResult in
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
    
    private func anyDetail() -> Detailed {
        let model = Detailed(uid: UUID(), setName: "any set", weight: 10, isDone: true, reps: 10, id: "any id")
        return (model)
    }
    
    private func anyDetails() -> (model: [Detailed], local: [DetailedDTO]) {
        let model = [anyDetail(), anyDetail(), anyDetail()]
        return (model, model.toLocal())
    }
    
    private func anyError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
}
