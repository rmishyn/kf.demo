//
//  ErrorCodes.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import Foundation

/// List of error codes
enum ErrorCode: Int {
    case invalidResponseDataType    = 10100
    case invalidResponse            = 10101
    case incorrectIdentifierType    = 10102
    case objectNotFound             = 10103
    
    var name: String {
        switch self {
        case .invalidResponseDataType:  return "Response uses unexpected format"
        case .invalidResponse:          return "Response is invalid"
        case .incorrectIdentifierType:  return "Incorrect identifier type"
        case .objectNotFound:           return "Object not found"
        }
    }
}

/// List of error domains
enum ErrorDomain: String {
    case networking = "Networking"
    case database = "Database"
}
