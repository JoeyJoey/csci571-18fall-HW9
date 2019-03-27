//
//  NetworkService.swift
//  HW9
//
//  Created by Joey on 11/29/18.
//  Copyright © 2018 Joey. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class NetworkService: NSObject {
    struct CustomEncoding: ParameterEncoding {
        func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
            var request = try! URLEncoding().encode(urlRequest, with: parameters)
            let urlString = request.url?.absoluteString.replacingOccurrences(of: "%5B%5D=", with: "=")
            request.url = URL(string: urlString!)
            return request
        }
    }
    func GetUpcoming(para:Parameters, finishedCallBack: @escaping (_ result : Any)->()){
        let URLString = "\(backURL)/upComingSearch";
        Alamofire.request(URLString, parameters: para).validate().responseJSON(completionHandler: {
            (response) in
            let json = JSON(response.result.value as Any) ;
            finishedCallBack(json);
        })
    }
}
