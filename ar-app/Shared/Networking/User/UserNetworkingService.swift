//
//  UserNetworkingService.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/16/22.
//

import Foundation

class UserNetworkingService {
    class func getUsers() {}
    
    class func getUser(id: String, completion: ((User?, Error?)->())?) {
        let request = UserAPIService().get(id: id)?.validate()
        request?.response(completionHandler: { data in
            switch data.result {
            case.success:
                if let jsonData = data.data, let result = try? JSONDecoder().decode(User?.self, from: jsonData) {
                    completion?(result, nil)
                } else {
                    completion?(nil, NSError.standard(message: "Data error. Could not decode User Object", code: -1))
                }
            case .failure(let error):
                completion?(nil, error)
            }
        })
    }
    
    class func getUserByCognitoId(id: String, completion: ((User?, Error?)->())?) {
        let request = UserAPIService().get(id: id)?.validate()
        request?.response(completionHandler: { data in
            switch data.result {
            case.success:
                if let jsonData = data.data, let result = try? JSONDecoder().decode(User?.self, from: jsonData) {
                    completion?(result, nil)
                } else {
                    completion?(nil, NSError.standard(message: "Data error. Could not decode User Object", code: -1))
                }
            case .failure(let error):
                completion?(nil, error)
            }
        })
    }
    
    class func saveUser(user: User?, completion:((User?, Error?)->())?) {
        guard let user = user,
              let data = try? JSONEncoder().encode(user),
              let parameters = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        else {
            completion?(nil, NSError.standard(message: "Data encoding error.", code: -1))
            return
        }
        let request = UserAPIService().save(params: parameters)?.validate()
        request?.response(completionHandler: { data in
            switch data.result {
            case .success:
                if let jsonData = data.data, let result = try? JSONDecoder().decode(User?.self, from: jsonData) {
                    completion?(result, nil)
                } else {
                    completion?(nil, NSError.standard(message: "Data error.", code: -1))
                }
            case .failure(let error):
                completion?(nil, error)
            }
        })
    }
    
    class func deleteUser() {}
    
}
