//
//  ServerService.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import Foundation
import Alamofire

typealias ServerResponseCompletion<T> = (Result<T>, DataResponse<Data>?) -> Void

/// Protocol describing requirements to service which provides interaction with remote server using URL request
protocol ServerService {
    /// Perform URL request
    /// - Parameters:
    ///     - request: A data item which can be represented as URL request
    ///     - completion: Closure called after request is performed. Used to return response data or error description (if request failed)
    func performRequest<T>(_ request: URLRequestConvertible, completion: ServerResponseCompletion<T>?)
    /// Perform URL request supporting a `multipartFormData` data uploading
    ///     - request: A data item which can be represented as URL request
    ///     - multipartFormData: Closure used to add data to request
    ///     - progress: Closure used to provide periodical progress status update of data uploading
    ///     - completion: Closure called after request is performed. Used to return response data or error description (if request failed)
    func performUploadingRequest<T>(_ request: URLRequestConvertible, multipartFormData: @escaping (MultipartFormData)->(), progress: DoubleCompletion?, completion: ServerResponseCompletion<T>?)
}
