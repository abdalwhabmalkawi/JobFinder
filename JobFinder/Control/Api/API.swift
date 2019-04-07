//
//  API.swift
//  JobFinder
//
//  Created by Taha on 4/6/19.
//  Copyright © 2019 Malkawi. All rights reserved.
//

import Foundation
import Alamofire

typealias Response = DataResponse

class API {
    
    
    static var sharedInstance = API()
    let session : SessionManager = {
        let configuration = URLSessionConfiguration.default
        let s = SessionManager(configuration: configuration)
        return s
    }()
    
    
    func Request<T : Decodable>(endPoint: URLRequestConvertible,complition: @escaping(_ response: Response<T>)-> Void) {
        let request = API.sharedInstance.session.request(endPoint)
        request.validate(statusCode: 200...300).responseDecodable { (response: DataResponse<T>) in
            complition(response)
        }
    }
    
}
extension DataRequest {
    func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }
            
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            let decoder = JSONDecoder()
            return Result { try decoder.decode(T.self, from: data) }
        }
    }
    
    @discardableResult
    func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }
}
