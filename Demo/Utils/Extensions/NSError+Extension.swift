//
//  NSError+Extension.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import Foundation

let NSErrorDataKey = "data"
let NSErrorDetailsKey = "details"

extension NSError {
    
    /// Initialize `NSError` with domain and code cases
    /// - Parameters:
    ///   - domain: Error domain case
    ///   - errorCode: Error code case
    convenience init(domain: ErrorDomain, errorCode: ErrorCode) {
        self.init(domain: domain.rawValue, code: errorCode.rawValue, userInfo: [NSLocalizedDescriptionKey: errorCode.name])
    }
    
    /// Initialize `NSError` with domain case, int code and error description
    /// - Parameters:
    ///   - domain: Error domain case
    ///   - code: Error code
    ///   - message: Error description
    convenience init(domain: ErrorDomain, code: Int, message: String, data: [String:Any]? = nil) {
        var userInfo: [String:Any] = [NSLocalizedDescriptionKey: message]
        if let data = data { userInfo[NSErrorDataKey] = data }
        self.init(domain: domain.rawValue, code: code, userInfo: userInfo)
    }
}
