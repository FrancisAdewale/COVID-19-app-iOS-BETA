//
//  StatusViewControllerTests.swift
//  SonarTests
//
//  Created by NHSX on 4/8/20.
//  Copyright © 2020 NHSX. All rights reserved.
//

import XCTest
@testable import Sonar

class StatusViewControllerTests: XCTestCase {

    func testShowsInitialRegisteredStatus() {
        let vc = makeViewController(persistence: PersistenceDouble(registration: Registration.fake))
        
        XCTAssertEqual(vc.registrationStatusText?.text, "The app is working properly")
        XCTAssertEqual(vc.registrationStatusIcon?.image, UIImage(named: "Registration_status_ok"))
        XCTAssertFalse(vc.registrationStatusIcon?.isHidden ?? true)
        XCTAssertTrue(vc.registrationSpinner?.isHidden ?? false)
        XCTAssertNil(vc.registratonStatusView?.backgroundColor)
        XCTAssertEqual(vc.registrationStatusText?.textColor, UIColor(named: "NHS Text"))
        XCTAssertTrue(vc.registrationRetryButton?.isHidden ?? false)
    }
    
    func testShowsInitialInProgressStatus() {
        let vc = makeViewController(persistence: PersistenceDouble(registration: nil))
        
        XCTAssertEqual(vc.registrationStatusText?.text, "Finalising setup...")
        XCTAssertTrue(vc.registrationStatusIcon?.isHidden ?? false)
        XCTAssertFalse(vc.registrationSpinner?.isHidden ?? true)
        XCTAssertNil(vc.registratonStatusView?.backgroundColor)
        XCTAssertEqual(vc.registrationStatusText?.textColor, UIColor(named: "NHS Text"))
        XCTAssertTrue(vc.registrationRetryButton?.isHidden ?? false)
    }
    
    func testStartsRegistrationOnShownWhenNotAlreadyRegistered() {
        let registrationService = RegistrationServiceDouble()
        _ = makeViewController(persistence: PersistenceDouble(registration: nil), registrationService: registrationService)
        
        XCTAssertTrue(registrationService.registerCalled)
    }
    
    func testUpdatesAfterRegistrationCompletes() {
        let registrationService = RegistrationServiceDouble()
        let notificationCenter = NotificationCenter()
        let vc = makeViewController(persistence: PersistenceDouble(registration: nil), registrationService: registrationService, notificationCenter: notificationCenter)

        notificationCenter.post(name: RegistrationCompletedNotification, object: nil)
        
        XCTAssertEqual(vc.registrationStatusText?.text, "The app is working properly")
        XCTAssertEqual(vc.registrationStatusIcon?.image, UIImage(named: "Registration_status_ok"))
        XCTAssertFalse(vc.registrationStatusIcon?.isHidden ?? true)
        XCTAssertTrue(vc.registrationSpinner?.isHidden ?? false)
        XCTAssertNil(vc.registratonStatusView?.backgroundColor)
        XCTAssertEqual(vc.registrationStatusText?.textColor, UIColor(named: "NHS Text"))
        XCTAssertTrue(vc.registrationRetryButton?.isHidden ?? false)
    }
    
    func testUpdatesAfterRegistrationFails() {
        let registrationService = RegistrationServiceDouble()
        let notificationCenter = NotificationCenter()
        let vc = makeViewController(persistence: PersistenceDouble(registration: nil), registrationService: registrationService, notificationCenter: notificationCenter)

        notificationCenter.post(name: RegistrationFailedNotification, object: nil)

        XCTAssertEqual(vc.registrationStatusText?.text, "App setup failed")
        XCTAssertEqual(vc.registrationStatusIcon?.image, UIImage(named: "Registration_status_failure"))
        XCTAssertFalse(vc.registrationStatusIcon?.isHidden ?? true)
        XCTAssertTrue(vc.registrationSpinner?.isHidden ?? false)
        XCTAssertEqual(vc.registratonStatusView?.backgroundColor, UIColor(named: "Error Grey"))
        XCTAssertEqual(vc.registrationStatusText?.textColor, UIColor.white)
        XCTAssertFalse(vc.registrationRetryButton?.isHidden ?? true)
    }
    
    func testRetry() {
        let registrationService = RegistrationServiceDouble()
        let queueDouble = QueueDouble()
        let vc = makeViewController(persistence: PersistenceDouble(registration: nil), registrationService: registrationService)
        
        queueDouble.scheduledBlock?()
        
        registrationService.registerCalled = false
        vc.retryRegistrationTapped()
        
        XCTAssertTrue(registrationService.registerCalled)

        XCTAssertEqual(vc.registrationStatusText?.text, "Finalising setup...")
        XCTAssertTrue(vc.registrationStatusIcon?.isHidden ?? false)
        XCTAssertFalse(vc.registrationSpinner?.isHidden ?? true)
        XCTAssertNil(vc.registratonStatusView?.backgroundColor)
        XCTAssertEqual(vc.registrationStatusText?.textColor, UIColor(named: "NHS Text"))
        XCTAssertTrue(vc.registrationRetryButton?.isHidden ?? false)
    }

    func testReloadsOnPotentiallyExposedNotification() {
        let notificationCenter = NotificationCenter()
        let statusStateMachine = StatusStateMachiningDouble()
        let vc = makeViewController(
            notificationCenter: notificationCenter,
            statusStateMachine: statusStateMachine
        )
        XCTAssertEqual(vc.diagnosisTitleLabel.text, "Follow the current advice to stop the spread of coronavirus".localized)

        statusStateMachine.state = .exposed(StatusState.Exposed(exposureDate: Date()))
        notificationCenter.post(name: StatusStateMachine.StatusStateChangedNotification, object: nil)

        XCTAssertEqual(vc.diagnosisTitleLabel.text, "You have been near someone who has coronavirus symptoms".localized)
    }
    
    func testShowsBlueStatus() throws {
        throw XCTSkip("TODO: make this work for all time zones and on CI")

//        let midnightUTC = 1589414400
//        let midnightLocal = midnightUTC - TimeZone.current.secondsFromGMT()
//        let currentDate = Date.init(timeIntervalSince1970: TimeInterval(midnightLocal))
        
        let statusStateMachine = StatusStateMachiningDouble()
        let vc = makeViewController(persistence: PersistenceDouble(), statusStateMachine: statusStateMachine)
        
        XCTAssertFalse(vc.diagnosisDetailLabel.isHidden)
        XCTAssertEqual(vc.diagnosisDetailLabel.text, "Valid as of 7 May")
        XCTAssertEqual(vc.diagnosisTitleLabel.text, "Follow the current advice to stop the spread of coronavirus")
        XCTAssertTrue(vc.redStatusView.isHidden)
    }
    
    func testShowsAmberStatus() {
        // Since we inject in a GB locale but calculate expiry using the current calendar,
        // we do these shenanigans to get a suitable date to result in 28 May being the
        // expiry in GB time.
        let exposureDate = Calendar.current
            .date(from: DateComponents(month: 5, day: 14))!
            .addingTimeInterval(TimeInterval(-TimeZone.current.secondsFromGMT()))

        let statusStateMachine = StatusStateMachiningDouble(state: .exposed(StatusState.Exposed(exposureDate: exposureDate)))
        let vc = makeViewController(statusStateMachine: statusStateMachine)

        XCTAssertFalse(vc.diagnosisDetailLabel.isHidden)

        //
        XCTAssertEqual(vc.diagnosisDetailLabel.text, "Follow this advice until 28 May")

        XCTAssertEqual(vc.diagnosisTitleLabel.text, "You have been near someone who has coronavirus symptoms")
        XCTAssertTrue(vc.redStatusView.isHidden)
    }
    
    func testShowsRedStatusForInitialSelfDiagnosis() {
        let startDate = Calendar.current.date(from: DateComponents(month: 5, day: 7))!
        let statusStateMachine = StatusStateMachiningDouble(
            state: .symptomatic(StatusState.Symptomatic(
                symptoms: [.cough],
                startDate: startDate
            ))
        )
        let vc = makeViewController(statusStateMachine: statusStateMachine)
        
        XCTAssertEqual(vc.diagnosisTitleLabel.text, "Your symptoms indicate you may have coronavirus")
        XCTAssertFalse(vc.diagnosisDetailLabel.isHidden)
        XCTAssertEqual(vc.diagnosisDetailLabel.text, "Follow this advice until 14 May, at which point this app will notify you to update your symptoms.")
        XCTAssertFalse(vc.redStatusView.isHidden)
    }

    func testShowsRedStatusForCheckin() {
        let statusStateMachine = StatusStateMachiningDouble(
            state: .checkin(StatusState.Checkin(symptoms: [.temperature], checkinDate: Date()))
        )
        let vc = makeViewController(statusStateMachine: statusStateMachine)
        
        XCTAssertEqual(vc.diagnosisTitleLabel.text, "Your symptoms indicate you may have coronavirus")
        XCTAssertFalse(vc.diagnosisDetailLabel.isHidden)
        XCTAssertEqual(vc.diagnosisDetailLabel.text, "Follow this advice until your temperature returns to normal")
        XCTAssertFalse(vc.redStatusView.isHidden)
    }
    
    func testReadLatestAdviceLabelWhenDefaultStatus() {
        let statusStateMachine = StatusStateMachiningDouble(state: .ok(StatusState.Ok()))
        let vc = makeViewController(statusStateMachine: statusStateMachine)
        
        XCTAssertEqual(vc.readLatestAdviceLabel.text, "Read current advice")
    }

    func testReadLatestAdviceLabelWhenAmberStatus() {
        let statusStateMachine = StatusStateMachiningDouble(state: .exposed(StatusState.Exposed(exposureDate: Date())))
        let vc = makeViewController(statusStateMachine: statusStateMachine)

        XCTAssertEqual(vc.readLatestAdviceLabel.text, "Read what to do next")
    }
    
    func testReadLatestAdviceLabelWhenRedStatus() {
        let statusStateMachine = StatusStateMachiningDouble(state: .symptomatic(StatusState.Symptomatic(symptoms: [.cough], startDate: Date())))
        let vc = makeViewController(statusStateMachine: statusStateMachine)

        XCTAssertEqual(vc.readLatestAdviceLabel.text, "Read what to do next")
    }
}

fileprivate func makeViewController(
    persistence: Persisting = PersistenceDouble(),
    registrationService: RegistrationService = RegistrationServiceDouble(),
    notificationCenter: NotificationCenter = NotificationCenter(),
    statusStateMachine: StatusStateMachining = StatusStateMachiningDouble()
) -> StatusViewController {
    let vc = StatusViewController.instantiate()
    vc.inject(
        persistence: persistence,
        registrationService: registrationService,
        notificationCenter: notificationCenter,
        linkingIdManager: LinkingIdManagerDouble.make(),
        statusStateMachine: statusStateMachine,
        localeProvider: EnGbLocaleProviderDouble()
    )
    XCTAssertNotNil(vc.view)
    vc.viewWillAppear(false)
    return vc
}
