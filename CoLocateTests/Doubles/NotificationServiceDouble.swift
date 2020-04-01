//
//  NotificationServiceDouble.swift
//  CoLocateTests
//
//  Created by NHSX.
//  Copyright © 2020 NHSX. All rights reserved.
//

import Foundation
@testable import CoLocate

class NotificationManagerDouble: NotificationManager {
    var pushToken: String?

    var delegate: NotificationManagerDelegate?

    func configure() { }

    var completion: ((Result<Bool, Error>) -> Void)?
    func requestAuthorization(completion: @escaping (Result<Bool, Error>) -> Void) {
        self.completion = completion
    }

    func handleNotification(userInfo: [AnyHashable : Any]) {
    }
}
