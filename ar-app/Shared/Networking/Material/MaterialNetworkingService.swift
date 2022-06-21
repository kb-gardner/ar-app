//
//  MaterialNetworkingService.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/16/22.
//

import Foundation

class MaterialNetworkingService {
    class func getMaterial(id: String, completion: ((Material?, Error?)->())?) {
        let request = MaterialAPIService().get(id: id).validate()
        request.responseDecodable(of: Material?.self) { response in
            switch response.result {
            case.success:
                if let result = response.value {
                    completion?(result, nil)
                } else {
                    completion?(nil, NSError.standard(message: "Data error. Could not decode Material Object", code: -1))
                }
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
    
    class func listMaterials(userId: String, completion: (([Material]?, Error?)->())?) {
        let params: [String: Any] = ["userId": userId]
        let request = MaterialAPIService().list(params: params).validate()
        request.responseDecodable(of: [Material].self) { response in
            switch response.result {
            case.success:
                if let result = response.value {
                    completion?(result, nil)
                } else {
                    completion?(nil, NSError.standard(message: "Data error. Could not decode Material Objects", code: -1))
                }
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
    
    class func createMaterial(material: Material?, completion:((Material?, Error?)->())?) {
        guard let material = material,
              let data = try? JSONEncoder().encode(material),
              let parameters = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        else {
            completion?(nil, NSError.standard(message: "Data encoding error.", code: -1))
            return
        }
        let request = MaterialAPIService().create(params: parameters).validate()
        request.responseDecodable(of: Material?.self) { response in
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
    
    class func updateMaterial(material: Material?, completion:((Material?, Error?)->())?) {
        guard let material = material,
              let id = material.id,
              let data = try? JSONEncoder().encode(material),
              let parameters = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        else {
            completion?(nil, NSError.standard(message: "Data encoding error.", code: -1))
            return
        }
        let request = MaterialAPIService().update(id: id, params: parameters).validate()
        request.responseDecodable(of: Material?.self) { response in
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
    
    class func deleteMaterial(id: String, completion:((Error?)->())?) {
        let request = MaterialAPIService().delete(id: id).validate()
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
