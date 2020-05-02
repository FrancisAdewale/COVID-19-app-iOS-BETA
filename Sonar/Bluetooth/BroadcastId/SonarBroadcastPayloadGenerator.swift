//
//  ConcreteBroadcastIdGenerator.swift
//  Sonar
//
//  Created by NHSX.
//  Copyright © 2020 NHSX. All rights reserved.
//

import Foundation
import Logging

protocol BroadcastPayloadGenerator {
    func broadcastPayload(date: Date) -> BroadcastPayload?
}

extension BroadcastPayloadGenerator {
    func broadcastPayload(date: Date = Date()) -> BroadcastPayload? {
        return broadcastPayload(date: date)
    }
}

class SonarBroadcastPayloadGenerator: BroadcastPayloadGenerator {

    let storage: BroadcastRotationKeyStorage
    let persistence: Persisting
    let provider: BroadcastIdEncrypterProvider

    init(storage: BroadcastRotationKeyStorage, persistence: Persisting, provider: BroadcastIdEncrypterProvider) {
        self.storage = storage
        self.persistence = persistence
        self.provider = provider
    }

    func broadcastPayload(date: Date) -> BroadcastPayload? {
        guard let registration = persistence.registration else { return nil }

        let hmacKey = registration.secretKey

        // TODO: Using the UTC calendar here to try and ensure isDateInToday() uses "today UTC" is not tested, but should be—need minute to midnight, midnight, minute past midnight tests
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        if let (broadcastId, broadcastIdDate) = storage.readBroadcastId(), calendar.isDateInToday(broadcastIdDate) {
            return BroadcastPayload(cryptogram: broadcastId, hmacKey: hmacKey)
        }
        
        let midnightUTC = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: date)!)

        if let broadcastId = provider.getEncrypter()?.broadcastId(from: date, until: midnightUTC) {
            storage.save(broadcastId: broadcastId, date: date)
            return BroadcastPayload(cryptogram: broadcastId, hmacKey: hmacKey)
        } else {
            return nil
        }
    }

}

fileprivate let logger = Logger(label: "BTLE")
