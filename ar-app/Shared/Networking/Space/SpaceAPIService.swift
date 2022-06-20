//
//  SpaceAPIService.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/16/22.
//

import Foundation
import Alamofire
import SwiftyJSON

class SpaceAPIService {
    func get(id: String) -> DataRequest {
        return AFSessionManager.sharedManager.request(Global.ServerAPI.url + "spaces/\(id)", method: .get, headers: HTTPHeaders.default)
    }
    
    func list(params: Parameters) -> DataRequest {
        return AFSessionManager.sharedManager.request(Global.ServerAPI.url + "spaces", method: .get, parameters: params, headers: HTTPHeaders.default)
    }
    
    func update(id: String, params: Parameters) -> DataRequest {
        return AFSessionManager.sharedManager.request(Global.ServerAPI.url + "spaces/\(id)", method: .put, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders.default)
    }
    
    func create(params: Parameters) -> DataRequest {
        return AFSessionManager.sharedManager.request(Global.ServerAPI.url + "spaces", method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders.default)
    }
    
    func delete(id: String) -> DataRequest {
        return AFSessionManager.sharedManager.request(Global.ServerAPI.url + "spaces/\(id)", method: .delete, headers: HTTPHeaders.default)
    }
    
}
