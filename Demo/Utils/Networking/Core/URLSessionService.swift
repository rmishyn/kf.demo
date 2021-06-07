//
//  URLSessionService.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import Foundation
import Alamofire

/// Service which provides interaction with remote server
class URLSessionService: ServerService {
    
    // MARK: Lifecycle
    
    /// Initializer
    init() { }
    
    // MARK: ServerService
    
    func processResponse<T>(_ responseData: DataResponse<Data>, completion: ServerResponseCompletion<T>?) {
        
        dprint(category: .networking, "response:\n\(responseData) / X-Log-Trace-ID: \(responseData.response?.value(forHTTPHeaderField: "X-Log-Trace-ID") ?? "unavailable")")
        var result: Result<T>
        let _completion = completion
        defer {
            _completion?(result, responseData)
        }
        let response = responseData.response!
        switch response.statusCode {
        case 200...299:
            dprint(category: .networking, "response (success): code=\(response.statusCode) / url=\(String(describing: response.url))")
            guard let data = responseData.data as? T else { return result = .failure(NSError(domain: .networking, errorCode: .invalidResponseDataType)) }
            //dprint("   \(String(describing: String(data: responseData.data!, encoding: .utf8)))")
            result = .success(data)
        default:
            dprint(category: .networking, "response (failed): code=\(String(describing: responseData.response?.statusCode)) / url=\(String(describing: responseData.response?.url))")
            var errorDetails: [String : Any]?
            if let data = responseData.data, let errorDataString = String(data: data, encoding: .utf8) {
                errorDetails = [NSErrorDetailsKey : errorDataString]
            }
            let error = NSError(domain: .networking, code: response.statusCode, message: HTTPURLResponse.localizedString(forStatusCode: response.statusCode), data: errorDetails)
            result = .failure(error)
        }
    }
    
    
    func performRequest<T>(_ request: URLRequestConvertible, completion: ServerResponseCompletion<T>?) {
        dprint(category: .networking, "Try to send request: \(request.path)")
        guard let _request = try? request.asURLRequest() else { dprint(category: .networking, "cancel (guard)"); return }
        dprint(category: .networking, "Send request:\n\(_request.curlString)")
        Alamofire.request(_request).responseData(completionHandler: { [weak self] (responseData) in
            dprint(category: .networking, "response received")
            guard let self = self else { return }
            dprint(category: .networking, "process response")
            self.processResponse(responseData, completion: completion)
        })
    }
    
    func performUploadingRequest<T>(_ request: URLRequestConvertible, multipartFormData: @escaping (MultipartFormData)->(), progress progr: DoubleCompletion?, completion: ServerResponseCompletion<T>?) {
        guard let _request = try? request.asURLRequest() else { return }
        dprint(category: .networking, "Send request:\n\(_request.curlString)")
        Alamofire.upload(multipartFormData: multipartFormData, with: _request) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print("--- Upload Progress: \(progress.fractionCompleted)")
                    progr?(progress.fractionCompleted)
                })
                upload.responseData { [weak self] (responseData) in
                    dprint(category: .networking, "Upload: success")
                    guard let self = self else { return }
                    self.processResponse(responseData, completion: completion)
                }
            case .failure(let encodingError):
                dprint(category: .networking, "Upload: encoding error: \(encodingError)")
                completion?(.failure(encodingError), nil)
            }
        }
    }
}
