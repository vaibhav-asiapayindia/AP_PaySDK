//
//  Country.swift
//  PayDollar
//
//  Created by AsiaPay Limited on 02/01/19.
//  Copyright © 2019 AsiaPay Limited. All rights reserved.
//

import Foundation

struct Country : Codable {
    let code : String?
    let name : String?
    let highRisk: String?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case name = "name"
        case highRisk = "highRisk"
    }
}
