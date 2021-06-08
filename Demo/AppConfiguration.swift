//
//  AppConfiguration.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import UIKit

struct AppConfiguration {
    
    struct Networking {
        
        /// Base URL for API endpoints
        static let baseUrl = "https://stage-api.keyflow.com/capi"
        /// Default value of "Accept" header parameter in API requests
        static let defaultAcceptType = HTTPContentType.json.rawValue
        /// Default value of "Content-Type" header parameter in API requests
        static let defaultContentType = HTTPContentType.json.rawValue
        /// Path to images hosting. Used as prefix to build full URL to image
        static let imagesStorageUrl = "https://res.cloudinary.com/keyflow/image/upload/"
    }
    
    /// Constants describing an animations throughout app
    struct Animation {
        static let tableViewAnimation: UITableView.RowAnimation = .fade
        static let tableViewAnimationReload: UITableView.RowAnimation = .none
    }
    
    /// Constants used during development
    struct DevelopmentOptions {
        static let dprintNetworkingLoggingLimit = 3000
    }
    
    /// Default events request parameters
    struct DefaultEventsRequestParameters {
        static let lon = 59.33539270000001
        static let lat = 18.07379500000002
        static let placeId = "ChIJywtkGTF2X0YRZnedZ9MnDag"
        static let locationRadius = 20.0
        static let pageNumber = 1
        static let pageSize = 50
    }
}
