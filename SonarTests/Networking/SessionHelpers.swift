//
//  SessionHelpers.swift
//  SonarTests
//
//  Created by NHSX on 21.03.20.
//  Copyright © 2020 NHSX. All rights reserved.
//

import Foundation

import Foundation

@testable import Sonar

extension Request {

    var isMethodGET: Bool {
        switch method {
        case .get: return true
        default: return false
        }
    }
    
    var isMethodPOST: Bool {
        switch method {
        case .post: return true
        default: return false
        }
    }
    
    var isMethodPATCH: Bool {
        switch method {
        case .patch: return true
        default: return false
        }
    }
    
    var body: Data? {
        switch method {
        case .get: return nil
        case .post(let body): return body
        case .patch(let body): return body
        case .put: return nil
        }
    }
    
}
