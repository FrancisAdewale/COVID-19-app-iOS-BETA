//
//  LinkingIdManager.swift
//  CoLocate
//
//  Created by NHSX.
//  Copyright © 2020 NHSX. All rights reserved.
//

import Foundation

class LinkingIdManager {
    let persisting: Persisting
    let session: Session

    init(
        notificationCenter: NotificationCenter,
        persisting: Persisting,
        session: Session
    ) {
        self.persisting = persisting
        self.session = session

        notificationCenter.addObserver(
            forName: RegistrationCompletedNotification,
            object: nil,
            queue: nil
        ) { _ in
            self.fetchLinkingId()
        }
    }

    func fetchLinkingId() {
        guard let registration = persisting.registration else {
            return
        }

        let request = LinkingIdRequest(registration: registration)
        session.execute(request) { result in
            switch result {
            case .success(let linkingId):
                self.persisting.linkingId = linkingId
            case .failure:
                break
            }
        }
    }
}
