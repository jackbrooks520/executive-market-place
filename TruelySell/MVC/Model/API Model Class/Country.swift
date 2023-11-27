//
//  CountryList.swift
//  DreamsChat
//
//  Created by Leo Chelliah on 26/06/19.
//  Copyright © 2019 DreamGuys. All rights reserved.
//

import Foundation

// MARK: - Country
struct Country: Codable {
    let name, dialCode, code: String
    
    init() {
        name = ""
        dialCode = ""
        code = ""
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case dialCode = "dial_code"
        case code
    }
}

typealias Countries = [Country]
