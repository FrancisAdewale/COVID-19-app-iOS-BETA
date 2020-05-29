//
//  ErrorView.swift
//  Sonar
//
//  Created by NHSX on 25/5/2020
//  Copyright © 2020 NHSX. All rights reserved.
//

import UIKit


class ErrorView: IBView {
    let colour = UIColor(named: "NHS Error")!
    
    @IBOutlet weak var title: UILabel! 
    @IBOutlet weak var errorMessage: AccessibleErrorLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        title.text = "There is a problem"
        title.textColor = UIColor(named: "NHS Error")

        errorMessage.text = "Something is incorrect"
        errorMessage.textColor = UIColor(named: "NHS Error")

        layer.borderWidth = 3
        layer.borderColor = colour.cgColor

        backgroundColor = .clear
    }
}
