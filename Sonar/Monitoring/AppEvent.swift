//
//  AppEvent.swift
//  Sonar
//
//  Created by NHSX.
//  Copyright © 2020 NHSX. All rights reserved.
//

import Foundation

enum AppEvent: Equatable {
    enum RegistrationFailureReason: Equatable {
        case waitingForFCMTokenTimedOut
        case registrationCallFailed(statusCode: Int?)
        case waitingForActivationNotificationTimedOut
        case activationCallFailed(statusCode: Int?)
    }
    case partialPostcodeProvided
    case onboardingCompleted
    case registrationSucceeded
    case registrationFailed(reason: RegistrationFailureReason)
    case collectedContactEvents(yesterday: Int, all: Int)
}
