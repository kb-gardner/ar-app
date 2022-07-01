//
//  Project.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/16/22.
//

import Foundation

struct Project: Codable {
    var id: String?
    var name: String?
    var address: String?
    var city: String?
    var state: String?
    var zip: String?
    var imageUrls: [String]?
    var createdAt: Int?
    var userId: String?
    var imageUrl: String?
    var priceEstimate: Double?
}
