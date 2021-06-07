//
//  EventsAPIRouter.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import Foundation
import Alamofire

/// Enumeration describing API routes related to Events (as convertible to URLRequest object)
enum EventsAPIRouter: URLRequestConvertible {
    
    /// Fetch all events
    case getEvents(lat: Double, lon: Double, placeId: String, locationRadius: Double, pageNumber: Int, pageSize: Int)

    // MARK: URLRequestConvertible
    
    var method: HTTPMethod {
        switch self {
        case .getEvents: return .get
        }
    }
    
    var path: String {
        switch self {
        case .getEvents: return ServerAPI.Endpoint.events.rawValue
        }
    }
    
    var parameters: Parameters? {
        var parameters: Parameters?
        
        switch self {
        case .getEvents: parameters = nil
        }
        
        return parameters
    }
    
    var acceptType: String? { nil }
    var contentType: String? { nil }
    
    var query: Query? {
        var query: Query?
        
        switch self {
        case .getEvents(lat: let lat, lon: let lon, placeId: let placeId, locationRadius: let locationRadius, pageNumber: let pageNumber, pageSize: let pageSize):
            query = [ ServerAPI.QueryParameter.lat.rawValue : String(lat),
                      ServerAPI.QueryParameter.lon.rawValue : String(lon),
                      ServerAPI.QueryParameter.placeId.rawValue : placeId,
                      ServerAPI.QueryParameter.locationRadius.rawValue : String(locationRadius),
                      ServerAPI.QueryParameter.pageNumber.rawValue : String(pageNumber),
                      ServerAPI.QueryParameter.pageSize.rawValue : String(pageSize) ]
        }
        
        return query
    }
}
