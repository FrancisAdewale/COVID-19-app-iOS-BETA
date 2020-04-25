//
//  SymptomsPromptViewController.swift
//  CoLocate
//
//  Created by NHSX.
//  Copyright © 2020 NHSX. All rights reserved.
//

import UIKit

class SymptomsPromptViewController: UIViewController, Storyboarded {
    static var storyboardName = "Status"
    var persistence: Persisting!
    var statusViewController: StatusViewController!
        
    func inject(persistence: Persisting, statusViewController: StatusViewController) {
        self.persistence = persistence
        self.statusViewController = statusViewController
    }
    
    @IBAction func updateSymptoms(_ sender: Any) {
        let navigationController = UINavigationController()
        let coordinator = UpdateDiagnosisCoordinator(
            navigationController: navigationController,
            persisting: persistence,
            statusViewController: statusViewController
        )
        coordinator.start()
        navigationController.modalPresentationStyle = .fullScreen
        dismiss(animated: true, completion: nil)
        statusViewController.present(navigationController, animated: true)
    }
    
    @IBAction func noSymptoms(_ sender: Any) {
        persistence.selfDiagnosis = nil
        statusViewController.diagnosis = nil
        dismiss(animated: true, completion: nil)
    }
}
