

import UIKit
import Foundation
import Alamofire

typealias ServiceResponse = (Any?, NSError?) -> Void

class APIServiceManager: NSObject {
    
    static let shared = APIServiceManager()
    
    //******************************************************************************************************************
    //MARK: GET Request Type API
    //******************************************************************************************************************
    func api_Calling_Get_Request(url: String, onComplete: ServiceResponse?){
        
        AF.request(url, method: .get, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success(let json):
                    onComplete!(json, nil )
                case .failure(let error):
                    onComplete!(nil, error as NSError )
                }
        }
    }
}






























