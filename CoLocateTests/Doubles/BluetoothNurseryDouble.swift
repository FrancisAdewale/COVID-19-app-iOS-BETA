//
//  BluetoothNurseryDouble.swift
//  CoLocateTests
//
//  Created by NHSX.
//  Copyright © 2020 NHSX. All rights reserved.
//

import UIKit
@testable import CoLocate

class BluetoothNurseryDouble: BluetoothNursery {
    var broadcaster: BTLEBroadcaster?
        
    var stateObserver: BluetoothStateObserver?
    var contactEventRepository: ContactEventRepository = ContactEventRepositoryDouble()
    var contactEventPersister: ContactEventPersister = ContactEventPersisterDouble()
    var createListenerCalled = false
    var createBroadcasterCalled = false
    var startBluetoothCalled = false
    var registrationPassedToStartBluetooth: Registration?
    
    func startBluetooth(registration: Registration?) {
        startBluetoothCalled = true
        registrationPassedToStartBluetooth = registration
        stateObserver = BluetoothStateObserver(initialState: .unknown)
    }    
}
