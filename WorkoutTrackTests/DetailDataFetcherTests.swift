//
//  DataFetcherTests.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/16.
//

import XCTest
import GYMHack

protocol DetailLoaderStore {
    func retrieve()
}

class DetailDataFetcher {
    private let store: DetailLoaderStore
    
    init(store: DetailLoaderStore) {
        self.store = store
    }
    
    func load() {
        store.retrieve()
    }
}

final class DetailDataFetcherTests: XCTestCase {

    func test_init_doesNotMessageStore() {
        let store = DetailFeedStoreSpy()
        let sut = DetailDataFetcher(store: store)
        
        XCTAssertTrue(store.receivedMessage.isEmpty)
    }
    
    func test_load_requestDataRetrieval() {
        let store = DetailFeedStoreSpy()
        let sut = DetailDataFetcher(store: store)
        
        sut.load()
        
        XCTAssertEqual(store.receivedMessage, [.retrieve])
    }
    
    //MARK: - Helper

}
