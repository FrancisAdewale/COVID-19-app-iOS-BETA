//
//  CoughUpdateViewController.swift
//  Sonar
//
//  Created by NHSX.
//  Copyright © 2020 NHSX. All rights reserved.
//

import UIKit

class CoughUpdateViewController: UIViewController, Storyboarded {
    static var storyboardName = "Status"
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
