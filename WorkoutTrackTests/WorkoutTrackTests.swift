//
//  WorkoutTrackTests.swift
//  WorkoutTrackTests
//
//  Created by Min-Yang Huang on 2022/4/23.
//
import Foundation
import XCTest
import GYMHack

class WorkoutTrackTests: XCTestCase {
        
    func test_translation() {
        XCTAssertEqual("機械式坐姿卷腹", "Machine Crunch".localizeString(string: "zh-Hant"))
    }
    
    
}
