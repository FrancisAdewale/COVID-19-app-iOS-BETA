//
//  UIView_ScrollingTests.swift
//  SonarTests
//
//  Created by NHSX.
//  Copyright © 2020 NHSX. All rights reserved.
//

import XCTest
@testable import Sonar

class UIView_ScrollingTests: XCTestCase {
    func testFindAncestorScrollView_findsNearest() {
        let greatGrandparent = UIScrollView()
        let grandparent = UIScrollView()
        let parent = UIView()
        let subject = UIView()
        greatGrandparent.addSubview(grandparent)
        grandparent.addSubview(parent)
        parent.addSubview(subject)
        
        XCTAssertEqual(subject.findAncestorScrollView(), grandparent)
    }
    
    func testFindAncestorScrollView_returnsNilWhenNotFound() {
        XCTAssertNil(UIView().findAncestorScrollView())
    }
    
    func testFindAncestorScrollView_doesNotReturnSelf() {
        let parent = UIScrollView()
        let subject = UIScrollView()
        parent.addSubview(subject)
        
        XCTAssertEqual(subject.findAncestorScrollView(), parent)
    }
}
