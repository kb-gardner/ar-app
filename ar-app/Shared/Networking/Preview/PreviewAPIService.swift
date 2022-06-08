//
//  PreviewAPIService.swift
//  ar-app
//
//  Created by Kyle Gardner on 6/8/22.
//

import Foundation
import Alamofire

class PreviewAPIService {
    class func list() -> DataRequest {
        return AFSessionManager.sharedManager.request(Global.ServerAPI.url + "previews", method: .get, headers: HTTPHeaders.default)
    }
}
