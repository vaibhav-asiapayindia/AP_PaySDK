//
//  SRC.swift
//  PayDollar
//
//  Created by AsiaPay Limited on 02/01/19.
//  Copyright © 2019 AsiaPay Limited. All rights reserved.
//

import Foundation

struct Src : Codable {    
    let prc : String?
    let src : String?
    let description : String?
    
    enum CodingKeys: String, CodingKey {
        case prc
        case src
        case description
    }
    
    init(prc:String, src:String, description: String) {
        self.prc = prc
        self.src = src
        self.description = description
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(prc, forKey: .prc)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        prc = try container.decode(String.self, forKey: .prc)
        src = try container.decode(String.self, forKey: .src)
        description = try container.decode(String.self, forKey: .description)
    }
}

