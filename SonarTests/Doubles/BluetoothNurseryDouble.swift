//
//  BluetoothNurseryDouble.swift
//  SonarTests
//
//  Created by NHSX on 4/22/20.
//  Copyright © 2020 NHSX. All rights reserved.
//

import UIKit

@testable import Sonar

class BluetoothNurseryDouble: BluetoothNursery {
    var broadcaster: BTLEBroadcaster?
        
    var stateObserver: BluetoothStateObserving = BluetoothStateObserver(initialState: .unknown)
    var contactEventRepository: ContactEventRepository = ContactEventRepositoryDouble()
    var contactEventPersister: ContactEventPersister = ContactEventPersisterDouble()
    var createListenerCalled = false
    var createBroadcasterCalled = false
    var hasStarted = false
    var registrationPassedToStartBluetooth: Registration?
    var listener: BTLEListener? = ListenerDouble()
    
    func startBluetooth(registration: Registration?) {
        hasStarted = true
        registrationPassedToStartBluetooth = registration
    }    
}
