//
//  XCTest+MemoryLeaksTracking.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2024/2/4.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should've been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
