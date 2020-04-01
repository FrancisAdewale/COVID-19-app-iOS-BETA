//
//  PersistenceDouble.swift
//  CoLocateTests
//
//  Created by NHSX.
//  Copyright © 2020 NHSX. All rights reserved.
//

import UIKit
@testable import CoLocate

class PersistenceDouble: Persistence {

    init(
        allowedDataSharing: Bool = false,
        diagnosis: Diagnosis = .unknown,
        registration: Registration? = nil
    ) {
        self._allowedDataSharing = allowedDataSharing
        self._registration = registration
        self._diagnosis = diagnosis

        super.init(secureRegistrationStorage: SecureRegistrationStorage.shared)
    }

    private var _allowedDataSharing: Bool
    override var allowedDataSharing: Bool {
        get { _allowedDataSharing }
        set { _allowedDataSharing = newValue }
    }

    private var _registration: Registration?
    override var registration: Registration? {
        get { _registration }
        set { _registration = newValue }
    }

    private var _diagnosis: Diagnosis
    override var diagnosis: Diagnosis {
        get { _diagnosis }
        set { _diagnosis = newValue }
    }

}
