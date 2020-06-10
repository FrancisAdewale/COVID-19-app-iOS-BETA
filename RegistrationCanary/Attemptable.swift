//
//  Tryable.swift
//  RegistrationCanary
//
//  Created by NHSX on 6/10/20
//  Copyright © 2020 NHSX. All rights reserved.
//

import Foundation

enum AttemptableState {
    case initial
    case inProgress
    case succeeded
    case failed
}


protocol Attemptable {
    var delegate: AttemptableDelegate? { get set }
    var state: AttemptableState { get }
    var numAttempts: Int { get }
    var numSuccesses: Int { get }
    
    func attempt()
}

protocol AttemptableDelegate {
    func attemptableDidChange(_ sender: Attemptable)
}
