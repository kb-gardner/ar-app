//
//  TierNetworkingService.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/16/22.
//

import Foundation

class TierNetworkingService {
    class func getTier(id: String, completion: ((Tier?, Error?)->())?) {
        let request = TierAPIService().get(id: id).validate()
        request.responseDecodable(of: Tier?.self) { response in
            switch response.result {
            case.success:
                if let result = response.value {
                    completion?(result, nil)
                } else {
                    completion?(nil, NSError.standard(message: "Data error. Could not decode Tier Object", code: -1))
                }
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
    
    class func listTiers(completion: (([Tier]?, Error?)->())?) {
        let request = TierAPIService().list().validate()
        request.responseDecodable(of: [Tier]?.self) { response in
            switch response.result {
            case.success:
                if let result = response.value {
                    completion?(result, nil)
                } else {
                    completion?(nil, NSError.standard(message: "Data error. Could not decode Tier Objects", code: -1))
                }
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
}
