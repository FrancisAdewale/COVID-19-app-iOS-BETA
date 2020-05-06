//
//  LinkButton.swift
//  Sonar
//
//  Created by NHSX on 04/05/2020.
//  Copyright © 2020 NHSX. All rights reserved.
//

import UIKit

class LinkButton: ButtonWithDynamicType {
    func inject(title: String, external: Bool, style: UIFont.TextStyle) {
        if external {
            accessibilityTraits = .link
            accessibilityHint = "Opens in your browser".localized
        } else {
            accessibilityTraits = .button
        }
        
        titleLabel?.attributedText = NSAttributedString(string: title, attributes:
            [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: UIColor(named: "NHS Link")!,
                .font: UIFont.preferredFont(forTextStyle: style)
            ]
        )
        setTitle(title, for: .normal)
    }
}

