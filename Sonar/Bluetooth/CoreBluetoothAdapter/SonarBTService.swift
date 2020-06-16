//
//  SonarBTService.swift
//  Sonar
//
//  Created by NHSX on 16/6/20
//  Copyright © 2020 NHSX. All rights reserved.
//

import Foundation
import CoreBluetooth

class SonarBTService {
    private let cbService: CBService
    public var characteristics: [SonarBTCharacteristic]?
    
    init(_ service: CBService) {
        self.cbService = service
    }
    
    init(type UUID: SonarBTUUID, primary isPrimary: Bool) {
        self.cbService = CBMutableService(type: UUID, primary: isPrimary)
    }
    
    var uuid: SonarBTUUID {
        return cbService.uuid
    }
    
    var unwrap: CBService {
        return cbService
    }
    
    var unwrapMutable: CBMutableService {
        return cbService as! CBMutableService
    }
}
