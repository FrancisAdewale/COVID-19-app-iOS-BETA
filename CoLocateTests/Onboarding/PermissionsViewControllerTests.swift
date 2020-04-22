//
//  PermissionsViewControllerTests.swift
//  CoLocateTests
//
//  Created by NHSX.
//  Copyright © 2020 NHSX. All rights reserved.
//

import CoreBluetooth
import XCTest
@testable import CoLocate

class PermissionsViewControllerTests: TestCase {
    
    func testBluetoothNotDetermined_callsContinueHandlerWhenBothGranted() {
        let authManagerDouble = AuthorizationManagerDouble(bluetooth: .notDetermined)
        let remoteNotificationManagerDouble = RemoteNotificationManagerDouble()
        let vc = PermissionsViewController.instantiate()
        var continued = false
        vc.inject(authManager: authManagerDouble, remoteNotificationManager: remoteNotificationManagerDouble, uiQueue: QueueDouble()) {
            continued = true
        }

        parentViewControllerForTests.viewControllers = [vc]
        XCTAssertNotNil(vc.view)

        vc.didTapContinue()

        #if targetEnvironment(simulator)
        // We skip Bluetooth on the simulator.
        #else
        authManagerDouble.bluetooth = .allowed
        vc.btleBroadcaster(DummyBTLEBroadcaster(), didUpdateState: .poweredOn)
        #endif
        
        XCTAssertFalse(continued)
        XCTAssertNotNil(authManagerDouble.notificationsCompletion)
        authManagerDouble.notificationsCompletion?(.allowed)
        XCTAssertTrue(continued)
    }

    func testBluetoothNotDetermined_callsContinueHandlerOnChangeToDenied() {
        let authManagerDouble = AuthorizationManagerDouble(bluetooth: .notDetermined)
        let remoteNotificationManagerDouble = RemoteNotificationManagerDouble()
        let vc = PermissionsViewController.instantiate()
        var continued = false
        vc.inject(authManager: authManagerDouble, remoteNotificationManager: remoteNotificationManagerDouble, uiQueue: QueueDouble()) {
            continued = true
        }

        parentViewControllerForTests.viewControllers = [vc]
        XCTAssertNotNil(vc.view)

        vc.didTapContinue()
        
        #if targetEnvironment(simulator)
        // We skip Bluetooth on the simulator.
        #else
        authManagerDouble.bluetooth = .denied
        vc.btleBroadcaster(DummyBTLEBroadcaster(), didUpdateState: .poweredOn)
        #endif

        XCTAssert(continued)
    }
    
    func testBluetoothAllowed_promptsForNotificationWhenShown() {
        let authManagerDouble = AuthorizationManagerDouble(bluetooth: .allowed)
        let remoteNotificationManagerDouble = RemoteNotificationManagerDouble()
        let vc = PermissionsViewController.instantiate()
        var continued = false
        vc.inject(authManager: authManagerDouble, remoteNotificationManager: remoteNotificationManagerDouble, uiQueue: QueueDouble()) {
            continued = true
        }

        parentViewControllerForTests.viewControllers = [vc]
        XCTAssertNotNil(vc.view)

        XCTAssertFalse(continued)
        XCTAssertNotNil(authManagerDouble.notificationsCompletion)
        authManagerDouble.notificationsCompletion?(.allowed)
        XCTAssertTrue(continued)
    }

    func testPreventsDoubleSubmit() {
        let authManagerDouble = AuthorizationManagerDouble(bluetooth: .allowed)
        let remoteNotificationManagerDouble = RemoteNotificationManagerDouble()
        let vc = PermissionsViewController.instantiate()
        vc.inject(authManager: authManagerDouble, remoteNotificationManager: remoteNotificationManagerDouble, uiQueue: QueueDouble()) {}

        parentViewControllerForTests.viewControllers = [vc]
        XCTAssertNotNil(vc.view)

        vc.didTapContinue()
        
        XCTAssertNotNil(authManagerDouble.notificationsCompletion)
        authManagerDouble.notificationsCompletion = nil
        vc.didTapContinue()
        XCTAssertNil(authManagerDouble.notificationsCompletion)
    }
    
    func testBluetoothAlreadyDetermined() {
        let authManagerDouble = AuthorizationManagerDouble(bluetooth: .allowed)
        let remoteNotificationManagerDouble = RemoteNotificationManagerDouble()
        let vc = PermissionsViewController.instantiate()
        var continued = false
        vc.inject(authManager: authManagerDouble, remoteNotificationManager: remoteNotificationManagerDouble, uiQueue: QueueDouble()) {
            continued = true
        }

        parentViewControllerForTests.viewControllers = [vc]
        XCTAssertNotNil(vc.view)

        vc.didTapContinue()

        XCTAssertNotNil(authManagerDouble.notificationsCompletion)
        authManagerDouble.notificationsCompletion!(.notDetermined)

        XCTAssertNotNil(remoteNotificationManagerDouble.requestAuthorizationCompletion)
        remoteNotificationManagerDouble.requestAuthorizationCompletion?(.success(true))

        XCTAssert(continued)
    }

}

fileprivate struct DummyBTLEBroadcaster: BTLEBroadcaster {
    func tryStartAdvertising() { }
}
