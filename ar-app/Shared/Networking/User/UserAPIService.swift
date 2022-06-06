//
//  UserAPIService.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/16/22.
//

import Foundation
import Alamofire
import SwiftyJSON

class UserAPIService {
    func get(id: String) -> DataRequest {
        return AFSessionManager.sharedManager.request(Global.ServerAPI.url + "users/\(id)", method: .get, headers: HTTPHeaders.default)
    }

    func getByEmail(email: String) -> DataRequest {
        return AFSessionManager.sharedManager.request(Global.ServerAPI.url + "users/byEmail/\(email)", method: .get, headers: HTTPHeaders.default)
    }
    
    func update(id: String, params: Parameters) -> DataRequest {
        return AFSessionManager.sharedManager.request(Global.ServerAPI.url + "users/\(id)", method: .put, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders.default)
    }
    
    func create(params: Parameters) -> DataRequest {
        return AFSessionManager.sharedManager.request(Global.ServerAPI.url + "users", method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders.default)
    }
    
    func delete(id: String) -> DataRequest {
        return AFSessionManager.sharedManager.request(Global.ServerAPI.url + "users/\(id)", method: .delete, headers: HTTPHeaders.default)
    }
    
}
