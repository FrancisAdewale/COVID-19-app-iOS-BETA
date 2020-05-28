//
//  DrawerMailboxTests.swift
//  SonarTests
//
//  Created by NHSX on 5/27/20
//  Copyright © 2020 NHSX. All rights reserved.
//

import XCTest
@testable import Sonar

class DrawerMailboxTests: XCTestCase {

    var mailbox: DrawerMailbox!
    var persistence: PersistenceDouble!

    override func setUp() {
        super.setUp()

        persistence = PersistenceDouble()
        mailbox = DrawerMailbox(persistence: persistence)
    }

    func testNoMessages() {
        XCTAssertNil(mailbox.receive())
    }

    func testPushMessages() {
        mailbox.post(.unexposed)
        mailbox.post(.negativeTestResult(symptoms: [.cough]))
        XCTAssertEqual(persistence.drawerMessages, [.unexposed, .negativeTestResult(symptoms: [.cough])])

        XCTAssertEqual(mailbox.receive(), .unexposed)
        XCTAssertEqual(mailbox.receive(), .negativeTestResult(symptoms: [.cough]))
        XCTAssertNil(mailbox.receive())
    }

}

class DrawerMessageTests: XCTestCase {

    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    func testRoundtripUnexposed() throws {
        let message = DrawerMessage.unexposed
        let encoded = try encoder.encode(message)
        let decoded = try decoder.decode(DrawerMessage.self, from: encoded)
        XCTAssertEqual(decoded, message)
    }

    func testRoundtripSymptomsButNotSymptomatic() throws {
        let message = DrawerMessage.symptomsButNotSymptomatic
        let encoded = try encoder.encode(message)
        let decoded = try decoder.decode(DrawerMessage.self, from: encoded)
        XCTAssertEqual(decoded, message)
    }

    func testRoundtripPositive() throws {
        let message = DrawerMessage.positiveTestResult
        let encoded = try encoder.encode(message)
        let decoded = try decoder.decode(DrawerMessage.self, from: encoded)
        XCTAssertEqual(decoded, message)
    }

    func testRoundtripNegativeWithSymptoms() throws {
        let message = DrawerMessage.negativeTestResult(symptoms: [.cough])
        let encoded = try encoder.encode(message)
        let decoded = try decoder.decode(DrawerMessage.self, from: encoded)
        XCTAssertEqual(decoded, message)
    }

    func testRoundtripNegativeWithoutSymptoms() throws {
        let message = DrawerMessage.negativeTestResult(symptoms: nil)
        let encoded = try encoder.encode(message)
        let decoded = try decoder.decode(DrawerMessage.self, from: encoded)
        XCTAssertEqual(decoded, message)
    }

    func testRoundtripUnclear() throws {
        let message = DrawerMessage.unclearTestResult
        let encoded = try encoder.encode(message)
        let decoded = try decoder.decode(DrawerMessage.self, from: encoded)
        XCTAssertEqual(decoded, message)
    }

}
