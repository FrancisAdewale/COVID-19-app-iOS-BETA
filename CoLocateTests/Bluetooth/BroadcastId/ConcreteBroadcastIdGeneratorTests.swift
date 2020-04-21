//
//  ConcreteBroadcastIdGeneratorTests.swift
//  CoLocateTests
//
//  Created by NHSX.
//  Copyright © 2020 NHSX. All rights reserved.
//

import XCTest

@testable import CoLocate


class ConcreteBroadcastIdGeneratorTests: XCTestCase {

    private var subject: ConcreteBroadcastIdGenerator!
    private var storage: StubbedBroadcastRotationKeyStorage!

    override func setUp() {
        storage = StubbedBroadcastRotationKeyStorage(stubbedKey: nil)
        subject = ConcreteBroadcastIdGenerator(storage: storage)
    }

    func test_it_is_not_ready_initiially() {
        let identifier = subject.broadcastIdentifier()

        XCTAssertNil(identifier)
    }

    func test_it_is_still_not_ready_when_only_the_sonar_id_is_present() {
        subject.sonarId = UUID(uuidString: "054DDC35-0287-4247-97BE-D9A3AF012E36")!

        let identifier = subject.broadcastIdentifier()
        XCTAssertNil(identifier)
    }

    func test_it_is_still_not_ready_when_only_the_server_public_key_is_present() {
        storage.stubbedKey = knownGoodECPublicKey()

        let identifier = subject.broadcastIdentifier()
        XCTAssertNil(identifier)
    }
    
    func test_it_provides_the_encrypted_result_once_given_sonar_id_and_server_public_key() {
        storage.stubbedKey = knownGoodECPublicKey()
        subject.sonarId = UUID(uuidString: "054DDC35-0287-4247-97BE-D9A3AF012E36")!

        let identifier = subject.broadcastIdentifier()

        XCTAssertNotNil(identifier)
    }
}

fileprivate class StubbedBroadcastRotationKeyStorage: BroadcastRotationKeyStorage {
    var stubbedKey: SecKey?

    init(stubbedKey: SecKey? = nil) {
        self.stubbedKey = stubbedKey
    }

    func save(publicKey: SecKey) throws {

    }

    func read() -> SecKey? {
        return stubbedKey
    }

    func clear() throws {

    }
}
