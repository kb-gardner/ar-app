//
//  Material.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/16/22.
//

import Foundation

struct Material: Codable {
    var id: String?
    var name: String?
    var imageUrl: String?
    var userId: String?
    var isAvailable: Bool?
    var bestPrice: Double?
    var storeName: String?
    var amountType: String?
    var color: String?
    var height: Int?
    var width: Int?
    var measurementType: String?
    var summary: String?
    var isFavorite: Bool? = false
    
    var isAvailableMessage: String {
        return isAvailable == true ? R.string.localizable.available() : R.string.localizable.not_available()
    }
}
