//
//  UserNetworkingService.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/16/22.
//

import Foundation

class UserNetworkingService {
    class func getUser(id: String, completion: ((User?, Error?)->())?) {
        let request = UserAPIService().get(id: id).validate()
        request.responseDecodable(of: User?.self) { response in
            switch response.result {
            case.success:
                if let result = response.value {
                    completion?(result, nil)
                } else {
                    completion?(nil, NSError.standard(message: "Data error. Could not decode User Object", code: -1))
                }
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
    
    class func getUserByEmail(email: String, completion: ((User?, Error?)->())?) {
        let request = UserAPIService().getByEmail(email: email).validate()
        request.responseDecodable(of: User?.self) { response in
            switch response.result {
            case.success:
                if let result = response.value {
                    completion?(result, nil)
                } else {
                    completion?(nil, NSError.standard(message: "Data error. Could not decode User Object", code: -1))
                }
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
    
    class func createUser(user: User?, completion:((User?, Error?)->())?) {
        guard let user = user,
              let data = try? JSONEncoder().encode(user),
              let parameters = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        else {
            completion?(nil, NSError.standard(message: "Data encoding error.", code: -1))
            return
        }
        let request = UserAPIService().create(params: parameters).validate()
        request.responseDecodable(of: User?.self) { response in
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
    
    class func updateUser(user: User?, completion:((User?, Error?)->())?) {
        guard let user = user,
              let id = user.id,
              let data = try? JSONEncoder().encode(user),
              let parameters = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        else {
            completion?(nil, NSError.standard(message: "Data encoding error.", code: -1))
            return
        }
        let request = UserAPIService().update(id: id, params: parameters).validate()
        request.responseDecodable(of: User?.self) { response in
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
    
    class func deleteUser(id: String, completion:((Error?)->())?) {
        let request = UserAPIService().delete(id: id).validate()
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
