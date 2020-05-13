//
//  LinkingIdNavigationController.swift
//  Sonar
//
//  Created by NHSX.
//  Copyright © 2020 NHSX. All rights reserved.
//

import UIKit

class LinkingIdNavigationController: UINavigationController, Storyboarded {
    static let storyboardName = "LinkingId"

    var persisting: Persisting!
    var linkingIdManager: LinkingIdManaging!

    func inject(persisting: Persisting, linkingIdManager: LinkingIdManaging) {
        self.persisting = persisting
        self.linkingIdManager = linkingIdManager
    }
    
    override func viewDidLoad() {
        let linkingIdVc = viewControllers.first as! LinkingIdViewController
        linkingIdVc.inject(persisting: persisting, linkingIdManager: linkingIdManager)
    }
}
