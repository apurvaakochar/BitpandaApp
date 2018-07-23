//
//  ServerRequest.swift
//  Bitpanda
//
//  Created by Apurva Kochar on 7/20/18.
//  Copyright © 2018 Bitpanda. All rights reserved.
//

import Foundation
import Alamofire

class ServerRequest {
    static let endpoint = "https://api.coinmarketcap.com/v2/ticker/"
    
    func getRequest(_ path: String, completionHandler: @escaping ([String : Any], String) -> Void) {
        Alamofire.request(getURL(path: path), encoding: JSONEncoding.prettyPrinted).responseJSON{
            response in
            if let result = response.result.value as? [String:Any]{
                completionHandler(result, "")
            }
            else{
                completionHandler([:], "error")
            }
            
        }
    }
    
    private func getURL(path: String) -> String
    {
        return String(format: "%@/%@", ServerRequest.endpoint, path)
    }
}
