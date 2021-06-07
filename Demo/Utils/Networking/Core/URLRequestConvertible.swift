//
//  URLRequestConvertible.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import Foundation
import Alamofire

public typealias Query = [String: String]

/// Protocol describing a value which can be converted to `URLRequest`
protocol URLRequestConvertible {
    /// HTTP method of request
    var method: HTTPMethod { get }
    /// Url string built by combining base url (global) and custom endpoint from `ServerAPI.APIEndpoint` string representation
    var path: String { get }
    /// Body parameters - to be serialized as JSON
    var parameters: Parameters? { get }
    /// Define custom value of `Accept` HTTP request header parameter instead of default value
    var acceptType: String? { get }
    /// Define custom value of `Content-Type` HTTP request header parameter instead of default value
    var contentType: String? { get }
    /// Collection of properties (`[key:value]`) which should be added to URL string as parameters
    var query: Query? { get }
    /// Prepare URL request according to data
    /// - Returns: Prepared `URLRequest`
    func asURLRequest() throws -> URLRequest
}

extension URLRequest {
    
    /// Request as a string, which can be used with `curl` utility
    var curlString: String {
        guard let url = url else { return "" }
        var baseCommand = "curl \(url.absoluteString)"
        
        if httpMethod == "HEAD" {
            baseCommand += " --head"
        }
        
        var command = [baseCommand]
        
        if let method = httpMethod, method != "GET" && method != "HEAD" {
            command.append("-X \(method)")
        }

        if let headers = allHTTPHeaderFields {
            for (key, value) in headers where key != "Cookie" {
                command.append("-H '\(key): \(value)'")
            }
        }
        
        if let data = httpBody, let body = String(data: data, encoding: .utf8) {
            command.append("-d '\(body)'")
        }
        
        return command.joined(separator: " \\\n\t")
    }
}

extension URLRequestConvertible {
    
    func asURLRequest() throws -> URLRequest {
        
        var url: URL = try AppConfiguration.Networking.baseUrl.asURL()
        
        // Query
        if let query = query, var components = URLComponents(string: url.absoluteString) {
            var queryItems = components.queryItems ?? [URLQueryItem]()
            queryItems.append(contentsOf: query.map { element in URLQueryItem(name: element.key, value: element.value) } )
            components.queryItems = queryItems
            url = components.url!
        }
        
        var urlRequest = URLRequest(url: (path.count > 0) ? url.appendingPathComponent(path) : url)
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(acceptType ?? AppConfiguration.Networking.defaultAcceptType, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(contentType ?? AppConfiguration.Networking.defaultContentType, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}
