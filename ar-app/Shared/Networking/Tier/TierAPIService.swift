//
//  TierAPIService.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/16/22.
//

import Foundation
import Alamofire
import SwiftyJSON

class TierAPIService {
    func get(id: String) -> DataRequest {
        return AFSessionManager.sharedManager.request(Global.ServerAPI.url + "tiers/\(id)", method: .get, headers: HTTPHeaders.default)
    }
    
    func list() -> DataRequest {
        return AFSessionManager.sharedManager.request(Global.ServerAPI.url + "tiers", method: .get, headers: HTTPHeaders.default)
    }
    
}

