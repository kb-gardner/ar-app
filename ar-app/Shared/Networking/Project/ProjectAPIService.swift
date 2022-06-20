//
//  ProjectAPIService.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/16/22.
//

import Foundation
import Alamofire
import SwiftyJSON

class ProjectAPIService {
    func get(id: String) -> DataRequest {
        return AFSessionManager.sharedManager.request(Global.ServerAPI.url + "projects/\(id)", method: .get, headers: HTTPHeaders.default)
    }
    
    func list(params: Parameters) -> DataRequest {
        return AFSessionManager.sharedManager.request(Global.ServerAPI.url + "projects", method: .get, parameters: params, headers: HTTPHeaders.default)
    }
    
    func update(id: String, params: Parameters) -> DataRequest {
        return AFSessionManager.sharedManager.request(Global.ServerAPI.url + "projects/\(id)", method: .put, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders.default)
    }
    
    func create(params: Parameters) -> DataRequest {
        return AFSessionManager.sharedManager.request(Global.ServerAPI.url + "projects", method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders.default)
    }
    
    func delete(id: String) -> DataRequest {
        return AFSessionManager.sharedManager.request(Global.ServerAPI.url + "projects/\(id)", method: .delete, headers: HTTPHeaders.default)
    }
    
}
