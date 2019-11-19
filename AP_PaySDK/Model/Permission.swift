//
//  Permission.swift
//  PayDollarSDK
//
//  Created by AsiaPay Limited on 14/02/19.
//  Copyright © 2019 AsiaPay Limited. All rights reserved.
//

import Foundation

struct Permission: Codable {
    let master : String?
    let visa : String?
    
    
    enum CodingKeys: String, CodingKey {
        case master = "Master"
        case visa = "VISA"
    }
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        master = try values.decodeIfPresent(String.self, forKey: .master)
        visa = try values.decodeIfPresent(String.self, forKey: .visa)
    }
    
    
}

