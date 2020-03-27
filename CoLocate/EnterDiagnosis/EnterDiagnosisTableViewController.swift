//
//  TableViewController.swift
//  CoLocate
//
//  Created by NHSX.
//  Copyright © 2020 NHSX. All rights reserved.
//

import UIKit

class EnterDiagnosisTableViewController: UITableViewController, Storyboarded {
    static let storyboardName = "EnterDiagnosis"
    var coordinator: AppCoordinator?
    
    var diagnosisService: DiagnosisService = DiagnosisService.shared
    
    enum Rows: Int {
        case title, yes, no
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Diagnosis"
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case Rows.title.rawValue:
            break
            
        case Rows.yes.rawValue:
            diagnosisService.recordDiagnosis(.infected)
            // TODO: move this into the AppCoordinator?
            let vc = PleaseSelfIsolateViewController.instantiate()
            vc.coordinator = coordinator
            navigationController?.pushViewController(vc, animated: true)
            
        case Rows.no.rawValue:
            diagnosisService.recordDiagnosis(.notInfected)
            // TODO: move this into the AppCoordinator?
            let vc = OkNowViewController.instantiate()
            vc.coordinator = coordinator
            navigationController?.pushViewController(vc, animated: true)

        default:
            print("\(#file).\(#function) unknown indexPath selected: \(indexPath)")
        }
    }
}
