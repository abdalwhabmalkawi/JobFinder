//
//  GithubModel.swift
//  JobFinder
//
//  Created by Abdalwhab on 4/7/19.
//  Copyright © 2019 Malkawi. All rights reserved.
//

import Foundation
class GithubModel : Codable {
    var id : String?
    var type: String?
    var url: String?
    var created_at : String?
    var company: String?
    var company_url: String?
    var location: String?
    var title: String?
    var description: String?
    var how_to_apply: String?
    var company_logo: String?
    init(data: [String:Any]) {
        id = data["id"] as? String
        type = data["type"] as? String
        url = data["url"] as? String
        created_at = data["created_at"] as? String
        company = data["company"] as? String
        company_url = data["company_url"] as? String
        location = data["location"] as? String
        title = data["title"] as? String
        description = data["description"] as? String
        how_to_apply = data["how_to_apply"] as? String
        company_logo = data["company_logo"] as? String
    }
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case type = "type"
        case url = "url"
        case created_at = "created_at"
        case company = "company"
        case company_url = "company_url"
        case location = "location"
        case title = "title"
        case description = "description"
        case how_to_apply = "how_to_apply"
        case company_logo = "company_logo"
    }
    
}
