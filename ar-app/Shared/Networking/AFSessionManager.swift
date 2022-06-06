//
//  AFSessionManager.swift
//  ar-app
//
//  Created by Kyle Gardner on 6/6/22.
//

import Alamofire

class AFSessionManager: Alamofire.Session {
    static let sharedManager: AFSessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json",
                                               "Accept": "*/*",
                                               "Accept-Encoding": "gzip, deflate, br",
                                               "Connection": "keep-alive"]
        let manager = AFSessionManager(configuration: configuration)
        return manager
    }()
}
