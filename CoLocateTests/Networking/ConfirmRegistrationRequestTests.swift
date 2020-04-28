//
//  ConfirmRegistrationRequestTests.swift
//  SonarTests
//
//  Created by NHSX.
//  Copyright © 2020 NHSX. All rights reserved.
//

import XCTest
@testable import Sonar

class ConfirmRegistrationRequestTests: XCTestCase {
    
    let activationCode = "an activation code"
    let serverGeneratedId = UUID()
    let symmetricKey = Data(base64Encoded: "3bLIKs9B9UqVfqGatyJbiRGNW8zTBr2tgxYJh/el7pc=")!
    let serverPublicKey = Data(base64Encoded: "Y2FzaCBydWxlcyBldmVyeXRoaW5nIGFyb3VuZCBtZQo=")!

    let pushToken: String = "someBase64StringWeGotFromFirebase=="
    let deviceModel: String = "iDevice 42,17"
    let deviceOSVersion: String = "666.6"
    let postalCode: String = "AB90"

    var request: ConfirmRegistrationRequest!
    
    override func setUp() {
        request = ConfirmRegistrationRequest(activationCode: activationCode,
                                             pushToken: pushToken,
                                             deviceModel: deviceModel,
                                             deviceOSVersion: deviceOSVersion,
                                             postalCode: postalCode)

        super.setUp()
    }

    func testHttpMethod() {
        XCTAssertTrue(request.isMethodPOST)
    }
    
    func testPath() {
        XCTAssertEqual(request.path, "/api/devices")
    }
    
    func testHeaders() {
        XCTAssertEqual(request.headers.count, 2)
        XCTAssertEqual(request.headers["Accept"], "application/json")
        XCTAssertEqual(request.headers["Content-Type"], "application/json")
    }
    
    func testBody() {
        XCTAssertEqual(String(data: request.body!, encoding: .utf8)!,
"""
{"activationCode":"an activation code","deviceModel":"iDevice 42,17","deviceOSVersion":"666.6","pushToken":"someBase64StringWeGotFromFirebase==","postalCode":"AB90"}
""")
    }

    func testParseValidResponse() {
        let responseData =
        """
        {
            "id": "\(serverGeneratedId.uuidString)", "secretKey": "3bLIKs9B9UqVfqGatyJbiRGNW8zTBr2tgxYJh/el7pc=", "publicKey": "Y2FzaCBydWxlcyBldmVyeXRoaW5nIGFyb3VuZCBtZQo="
        }
        """.data(using: .utf8)!
        let response = try? request.parse(responseData)

        XCTAssertEqual(response?.id, serverGeneratedId)
        XCTAssertEqual(response?.secretKey, symmetricKey)
        XCTAssertEqual(response?.serverPublicKey, serverPublicKey)
    }

    func testParseInvalidUUID() {
        let responseData =
        """
        {
            "id": "uuid-blabalabla", "secretKey": "3bLIKs9B9UqVfqGatyJbiRGNW8zTBr2tgxYJh/el7pc=", "publicKey": "Y2FzaCBydWxlcyBldmVyeXRoaW5nIGFyb3VuZCBtZQo="
        }
        """.data(using: .utf8)!

        XCTAssertThrowsError(try request.parse(responseData))
    }

    func testParseInvalidSymmetricKey() {
        let responseData =
        """
        {
            "id": "\(serverGeneratedId.uuidString)", "secretKey": "random non-base64 nonsense", "publicKey": "Y2FzaCBydWxlcyBldmVyeXRoaW5nIGFyb3VuZCBtZQo="
        }
        """.data(using: .utf8)!

        XCTAssertThrowsError(try request.parse(responseData))
    }

    func testParseInvalidPublicKey() {
        let responseData =
        """
        {
            "id": "\(serverGeneratedId.uuidString)", "secretKey": "3bLIKs9B9UqVfqGatyJbiRGNW8zTBr2tgxYJh/el7pc=", "publicKey": "these are not the bytes you are looking for"
        }
        """.data(using: .utf8)!

        XCTAssertThrowsError(try request.parse(responseData))
    }
 }
