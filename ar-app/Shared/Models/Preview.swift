//
//  Preview.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/18/22.
//

import Foundation

struct Preview: Codable {
    let stringUrl: String?
    let title: String?
    let description: String?
    let contentType: String!
    
    var type: PreviewContentType {
        return PreviewContentType(rawValue: contentType) ?? .image
    }
}

enum PreviewContentType: String {
    case image
    case video
}
