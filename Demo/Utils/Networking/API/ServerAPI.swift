//
//  APIEndpoints.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import Foundation

/// Container for enumerations used to support backend API
struct ServerAPI {
    
    enum Endpoint: String {
        case events = "/v4/events"
    }
    
    enum QueryParameter: String {
        case lon = "long"
        case lat = "lat"
        case placeId = "placeId"
        case locationRadius = "locationRadius"
        case pageNumber = "pageNumber"
        case pageSize = "pageSize"
    }
    
    enum ResponseKey: String {
        case data = "data"
        case events = "events"
        case venues = "venues"
    }
}
