//
//  AuthManagerDouble.swift
//  SonarTests
//
//  Created by NHSX on 3/31/20.
//  Copyright © 2020 NHSX. All rights reserved.
//

import Foundation
@testable import Sonar

class AuthorizationManagerDouble: AuthorizationManaging {

    var bluetoothCompletion: ((BluetoothAuthorizationStatus) -> Void)?
    var notificationsCompletion: ((NotificationAuthorizationStatus) -> Void)?
    
    var bluetooth: BluetoothAuthorizationStatus
    
    init(bluetooth: BluetoothAuthorizationStatus = .notDetermined) {
        self.bluetooth = bluetooth
    }
    
    func waitForDeterminedBluetoothAuthorizationStatus(completion: @escaping (BluetoothAuthorizationStatus) -> Void) {
        bluetoothCompletion = completion
    }

    func notifications(completion: @escaping (NotificationAuthorizationStatus) -> Void) {
        notificationsCompletion = completion
    }

}
