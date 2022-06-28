//
//  Tier.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/16/22.
//

import Foundation
import UIKit

struct Tier: Codable {
    let id: String?
    let name: String?
    let summary: String?
    let rate: Double?
    let billingCycle: String?
    
    enum TierType: String {
        case free = "free"
        case diy = "diy expert"
        case contractor = "contractor"
        case pro = "contractor pro"
    }
    
    var image: UIImage? {
        switch TierType(rawValue: name ?? "") {
        case .free:
            return R.image.toolsFree()
        case .diy:
            return R.image.handDIY()
        case .contractor:
            return R.image.toolsContractor()
        case .pro:
            return R.image.hatContractorPro()
        default:
            return R.image.toolsFree()
        }
    }
    
    var isRecommended: Bool {
        return TierType(rawValue: name ?? "") == .contractor
    }
}
