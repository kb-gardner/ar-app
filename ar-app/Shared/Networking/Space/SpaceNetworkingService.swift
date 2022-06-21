//
//  SpaceNetworkingService.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/16/22.
//

import Foundation

class SpaceNetworkingService {
    class func getSpace(id: String, completion: ((Space?, Error?)->())?) {
        let request = SpaceAPIService().get(id: id).validate()
        request.responseDecodable(of: Space?.self) { response in
            switch response.result {
            case.success:
                if let result = response.value {
                    completion?(result, nil)
                } else {
                    completion?(nil, NSError.standard(message: "Data error. Could not decode Space Object", code: -1))
                }
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
    
    class func listSpaces(projectId: String? = nil, userId: String? = nil, completion: (([Space]?, Error?)->())?) {
        var params: [String: Any] = [:]
        if let projectId = projectId {
            params["projectId"] = projectId
        }
        if let userId = userId {
            params["userId"] = userId
        }
        let request = SpaceAPIService().list(params: params).validate()
        request.responseDecodable(of: [Space]?.self) { response in
            switch response.result {
            case.success:
                if let result = response.value {
                    completion?(result, nil)
                } else {
                    completion?(nil, NSError.standard(message: "Data error. Could not decode Space Objects", code: -1))
                }
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
    
    class func createSpace(space: Space?, completion:((Space?, Error?)->())?) {
        guard let space = space,
              let data = try? JSONEncoder().encode(space),
              let parameters = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        else {
            completion?(nil, NSError.standard(message: "Data encoding error.", code: -1))
            return
        }
        let request = SpaceAPIService().create(params: parameters).validate()
        request.responseDecodable(of: Space?.self) { response in
            switch response.result {
            case .success:
                if let result = response.value {
                    completion?(result, nil)
                } else {
                    completion?(nil, NSError.standard(message: "Data error.", code: -1))
                }
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
    
    class func updateSpace(space: Space?, completion:((Space?, Error?)->())?) {
        guard let space = space,
              let id = space.id,
              let data = try? JSONEncoder().encode(space),
              let parameters = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        else {
            completion?(nil, NSError.standard(message: "Data encoding error.", code: -1))
            return
        }
        let request = SpaceAPIService().update(id: id, params: parameters).validate()
        request.responseDecodable(of: Space?.self) { response in
            switch response.result {
            case .success:
                if let result = response.value {
                    completion?(result, nil)
                } else {
                    completion?(nil, NSError.standard(message: "Data error.", code: -1))
                }
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
    
    class func deleteSpace(id: String, completion:((Error?)->())?) {
        let request = SpaceAPIService().delete(id: id).validate()
        request.response(completionHandler: { data in
            switch data.result {
            case.success:
                completion?(nil)
            case .failure(let error):
                completion?(error)
            }
        })
    }
    
}
