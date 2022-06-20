//
//  ProjectNetworkingService.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/16/22.
//

import Foundation

class ProjectNetworkingService {
    class func getProject(id: String, completion: ((Project?, Error?)->())?) {
        let request = ProjectAPIService().get(id: id).validate()
        request.response(completionHandler: { data in
            switch data.result {
            case.success:
                if let jsonData = data.data, let result = try? JSONDecoder().decode(Project?.self, from: jsonData) {
                    completion?(result, nil)
                } else {
                    completion?(nil, NSError.standard(message: "Data error. Could not decode Project Object", code: -1))
                }
            case .failure(let error):
                completion?(nil, error)
            }
        })
    }
    
    class func listProjects(userId: String, completion: (([Project]?, Error?)->())?) {
        let params: [String: Any] = ["userId": userId]
        let request = ProjectAPIService().list(params: params).validate()
        request.response(completionHandler: { data in
            switch data.result {
            case.success:
                if let jsonData = data.data, let result = try? JSONDecoder().decode([Project]?.self, from: jsonData) {
                    completion?(result, nil)
                } else {
                    completion?(nil, NSError.standard(message: "Data error. Could not decode Project Objects", code: -1))
                }
            case .failure(let error):
                completion?(nil, error)
            }
        })
    }
    
    class func createProject(project: Project?, completion:((Project?, Error?)->())?) {
        guard let project = project,
              let data = try? JSONEncoder().encode(project),
              let parameters = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        else {
            completion?(nil, NSError.standard(message: "Data encoding error.", code: -1))
            return
        }
        let request = ProjectAPIService().create(params: parameters).validate()
        request.response(completionHandler: { data in
            switch data.result {
            case .success:
                if let jsonData = data.data, let result = try? JSONDecoder().decode(Project?.self, from: jsonData) {
                    completion?(result, nil)
                } else {
                    completion?(nil, NSError.standard(message: "Data error.", code: -1))
                }
            case .failure(let error):
                completion?(nil, error)
            }
        })
    }
    
    class func updateProject(project: Project?, completion:((Project?, Error?)->())?) {
        guard let project = project,
              let id = project.id,
              let data = try? JSONEncoder().encode(project),
              let parameters = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        else {
            completion?(nil, NSError.standard(message: "Data encoding error.", code: -1))
            return
        }
        let request = ProjectAPIService().update(id: id, params: parameters).validate()
        request.response(completionHandler: { data in
            switch data.result {
            case .success:
                if let jsonData = data.data, let result = try? JSONDecoder().decode(Project?.self, from: jsonData) {
                    completion?(result, nil)
                } else {
                    completion?(nil, NSError.standard(message: "Data error.", code: -1))
                }
            case .failure(let error):
                completion?(nil, error)
            }
        })
    }
    
    class func deleteProject(id: String, completion:((Error?)->())?) {
        let request = ProjectAPIService().delete(id: id).validate()
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
