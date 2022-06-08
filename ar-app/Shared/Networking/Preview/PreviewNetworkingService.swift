//
//  PreviewNetworkingService.swift
//  ar-app
//
//  Created by Kyle Gardner on 6/8/22.
//

import Foundation

class PreviewNetworkingService {
    class func getPreviews(completion: (([Preview]?, Error?)->())?) {
        let request = PreviewAPIService.list().validate()
        request.response(completionHandler: { data in
            switch data.result {
            case.success:
                if let jsonData = data.data, let result = try? JSONDecoder().decode([Preview]?.self, from: jsonData) {
                    completion?(result, nil)
                } else {
                    completion?(nil, NSError.standard(message: "Data error. Could not decode User Object", code: -1))
                }
            case .failure(let error):
                completion?(nil, error)
            }
        })
    }
}
