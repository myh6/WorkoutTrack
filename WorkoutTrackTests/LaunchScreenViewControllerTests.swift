//
//  LaunchScreenViewControllerTests.swift
//  GYMHackTests
//
//  Created by Min-Yang Huang on 2023/12/25.
//

import XCTest
@testable import GYMHack

class LaunchScreenViewControllerTests: XCTestCase {
    
    var sut: LaunchScreenViewController!
    
    override func setUp() {
        super.setUp()
        sut = LaunchScreenViewController()
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testViewController_HasWhiteBackgroundColor() {
        XCTAssertEqual(sut.view.backgroundColor, UIColor.white, "Background color should be white")
    }

    func testImageView_HasImageLoaded() {
        let imageView = sut.getImageView()
        XCTAssertNotNil(imageView?.image, "Image should be loaded")
    }

    func testImageView_AnimationDuration() {
        let expectedDuration = sut.getImage()!.duration
        XCTAssertEqual(sut.getImageView()!.animationDuration, expectedDuration, "Animation duration should be set correctly")
    }

    func testImageView_AnimationRepeatCount() {
        XCTAssertEqual(sut.getImageView()!.animationRepeatCount, 1, "Animation should repeat only once")
    }

    
}

