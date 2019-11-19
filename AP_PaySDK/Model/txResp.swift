
import Foundation

struct txResp : Codable {
    let data : String?
    let hash : String?
    let ts : String?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case hash = "hash"
        case ts = "ts"
    }
}


struct Dara1 : Codable {
    let detail : [Detail]?
    let resultCode : String?
    
    enum CodingKeys: String, CodingKey {
        case detail = "detail"
        case resultCode = "resultCode"
    }
}

