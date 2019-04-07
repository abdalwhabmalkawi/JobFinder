//
//  EndPoint.swift
//  JobFinder
//
//  Created by Abdalwhab on 4/6/19.
//  Copyright © 2019 Malkawi. All rights reserved.
//

import Foundation
import Alamofire

enum EndPint : URLRequestConvertible {
    static var bURL: String!
    case githubPosition(param:[String:String])
    case govSearch(param: [String:String])
    
    var method: HTTPMethod {
        switch self {
        case .githubPosition: return .get
        case .govSearch: return .get
        }
    }
    var path : String {
        switch self {
        case .githubPosition(let param): return "positions.json\(MakeParamForGetRequest(param: param))"
        case .govSearch(let param): return "jobs/search.json\(MakeParamForGetRequest(param: param))"
        }
    }

    func MakeParamForGetRequest(param: [String:String])-> String {
        var arr: [String] = []
        for (key,value) in param {
            arr.append("\(key)=\(value)")
        }
        let allParam = "?" + arr.joined(separator: "&")
        
        return allParam
    }
    func asURLRequest() throws -> URLRequest {
        
        let urlString = EndPint.bURL + path
        let url = try urlString.asURL()
        var urlRequest = URLRequest(url: url)
        print(urlRequest)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}
