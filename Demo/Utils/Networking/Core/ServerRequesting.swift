//
//  ServerRequesting.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import Foundation

/// Protocol used to describe services ability to perform API requests
protocol ServerRequesting {
    
    /// Service which provides interaction with remote server
    var core: ServerService {get}
    
    /// Perform URL request
    /// - Parameters:
    ///     - request: A data item which can be represented as URL request
    ///     - logLabel: String used to customize logging related to this request
    ///     - completion: Closure called after request is performed. Used to return request execution result (success or failed)
    func performRequest(_ request: URLRequestConvertible, logLabel: String, completion:  @escaping VoidResultCompletion)
    
    /// Perform URL request
    /// - Parameters:
    ///     - request: A data item which can be represented as URL request
    ///     - logLabel: String used to customize logging related to this request
    ///     - completion: Closure called after request is performed. Used to return raw response data or error description (if request or parsing failed)
    func performRequest(_ request: URLRequestConvertible, logLabel: String, completion:  @escaping DataResultCompletion)
    
    /// Perform URL request
    /// - Parameters:
    ///     - request: A data item which can be represented as URL request
    ///     - logLabel: String used to customize logging related to this request
    ///     - completion: Closure called after request is performed. Used to return response data parsed into dictionary or error description (if request or parsing failed)
    func performRequest(_ request: URLRequestConvertible, logLabel: String, completion:  @escaping DictResultCompletion)
    
    /// Perform URL request
    /// - Parameters:
    ///     - request: A data item which can be represented as URL request
    ///     - logLabel: String used to customize logging related to this request
    ///     - completion: Closure called after request is performed. Used to return response data parsed into array or error description (if request or parsing failed)
    func performRequest(_ request: URLRequestConvertible, logLabel: String, completion:  @escaping ArrResultCompletion)
}

extension ServerRequesting where Self: ServerResponseProcessing {
    
    func performRequest(_ request: URLRequestConvertible, logLabel: String, completion:  @escaping VoidResultCompletion) {
        core.performRequest(request) { [weak self] (result: Result<Data>, _) in
            self?.processDataResponseToVoid(result: result, logLabel: logLabel, completion: completion)
        }
    }
    
    func performRequest(_ request: URLRequestConvertible, logLabel: String, completion:  @escaping DataResultCompletion) {
        core.performRequest(request) { (result: Result<Data>, _) in
            completion(result)
        }
    }
    
    func performRequest(_ request: URLRequestConvertible, logLabel: String, completion:  @escaping DictResultCompletion) {
        core.performRequest(request) { [weak self] (result: Result<Data>, _) in
            self?.processDataResponseToDict(result: result, logLabel: logLabel, completion: completion)
        }
    }
    
    func performRequest(_ request: URLRequestConvertible, logLabel: String, completion:  @escaping ArrResultCompletion) {
        core.performRequest(request) { [weak self] (result: Result<Data>, _) in
            self?.processDataResponseToArr(result: result, logLabel: logLabel, completion: completion)
        }
    }
}
