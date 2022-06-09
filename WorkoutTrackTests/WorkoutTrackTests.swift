//
//  WorkoutTrackTests.swift
//  WorkoutTrackTests
//
//  Created by Min-Yang Huang on 2022/4/23.
//
import Foundation
import XCTest
@testable import GYMHack

class WorkoutTrackTests: XCTestCase {

    func test_translation() {
        let exercise = "機械式坐姿卷腹"
        XCTAssertEqual(exercise, "Machine Crunch".localizeString(string: "zh-Hant"))
    }

}
