//
//  ContactEventsUploaderDouble.swift
//  SonarTests
//
//  Created by NHSX on 4/23/20.
//  Copyright © 2020 NHSX. All rights reserved.
//

@testable import Sonar

class ContactEventsUploaderDouble: ContactEventsUploader {
    init() {
        super.init(
            persisting: PersistenceDouble(),
            contactEventRepository: ContactEventRepositoryDouble(),
            trustValidator: TrustValidatingDouble(),
            makeSession: { _, _ in SessionDouble() }
        )
    }

    var uploadStartDate: Date?
    var uploadSymptoms: Symptoms?
    override func upload(from startDate: Date, with symptoms: Symptoms) throws {
        uploadStartDate = startDate
        uploadSymptoms = symptoms
    }
}
