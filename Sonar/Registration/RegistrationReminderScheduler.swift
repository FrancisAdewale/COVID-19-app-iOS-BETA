//
//  RegistrationReminderScheduler.swift
//  Sonar
//
//  Created by NHSX on 4/24/20.
//  Copyright © 2020 NHSX. All rights reserved.
//

import UIKit

protocol RegistrationReminderScheduler {
    func schedule()
    func cancel()
}

class ConcreteRegistrationReminderScheduler: RegistrationReminderScheduler {
    private let userNotificationCenter: UserNotificationCenter
    
    init(userNotificationCenter: UserNotificationCenter) {
        self.userNotificationCenter = userNotificationCenter
    }

    func schedule() {
        let notificationScheduler = HumbleLocalNotificationScheduler(userNotificationCenter: userNotificationCenter)
        notificationScheduler.scheduleLocalNotification(title: nil, body: body, interval: 24 * 60 * 60, identifier: dailyIdentifier, repeats: true)
        notificationScheduler.scheduleLocalNotification(title: nil, body: body, interval: 60 * 60, identifier: oneTimeIdentifier, repeats: false)
    }
    
    func cancel() {
        userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [dailyIdentifier, oneTimeIdentifier])
    }
}

private let dailyIdentifier = "registration.reminder"
private let oneTimeIdentifier = "registration.oneTimeReminder"
private let body = "Your registration has failed. Please open the app and select retry to complete your registration."
