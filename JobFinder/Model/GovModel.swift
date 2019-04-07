//
//  GovModel.swift
//  JobFinder
//
//  Created by Abdalwhab on 4/7/19.
//  Copyright © 2019 Malkawi. All rights reserved.
//

import Foundation

class GovModel : Codable {
    var id: String?
    var url: String?
    var position_title: String?
    var organization_name: String?
    var rate_interval_code: String?
    var minimum: Int?
    var maximum: Int?
    var start_date: String?
    var end_date : String?
    var locations: [String]?
    init(data: [String:Any]) {
        id = data["id"] as? String
        url = data["url"] as? String
        position_title = data["position_title"] as? String
        organization_name = data["organization_name"] as? String
        rate_interval_code = data["rate_interval_code"] as? String
        minimum = data["minimum"] as? Int
        maximum = data["maximum"] as? Int
        start_date = data["start_date"] as? String
        end_date = data["end_date"] as? String
        locations = data["locations"] as? [String]
    }
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case url = "url"
        case position_title = "position_title"
        case organization_name = "organization_name"
        case rate_interval_code = "rate_interval_code"
        case minimum = "minimum"
        case maximum = "maximum"
        case start_date = "start_date"
        case end_date = "end_date"
        case locations = "locations"
    }
}
