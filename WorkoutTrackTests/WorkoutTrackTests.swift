//
//  WorkoutTrackTests.swift
//  WorkoutTrackTests
//
//  Created by Min-Yang Huang on 2022/4/23.
//
import Foundation
import XCTest
@testable import GYMHack
import CoreData

class WorkoutTrackTests: XCTestCase {
        
    func test_translation() {
        XCTAssertEqual("機械式坐姿卷腹", "Machine Crunch".localizeString(string: "zh-Hant"))
    }
    
    func test_whenInDebugState_ShouldReturnDebugEnvironment() {
        XCTAssertEqual(AppConfig.getTarget(), Environment.debug)
    }
}
