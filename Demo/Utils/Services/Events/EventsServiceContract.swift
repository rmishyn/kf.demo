//
//  EventsServiceProtocol.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import Foundation

/// Protocol describing a service which is used to support events related functionality
protocol EventsServiceProtocol {
    
    /// Fetch all events and save them into local database
    /// - Parameters:
    ///   - lat: A floating-point numbers representing longitude (decimal degrees)
    ///   - lon: A floating-point numbers representing latitude (decimal degrees)
    ///   - placeId: A string from google to uniquely identify a city. It is strongly recommended to also provide long & lat at the same time when using this param
    ///   - locationRadius: The range of a circle with locationCoordinates as center and locationRadius as radius in kilometers and 200 KM will be used if not given
    ///   - pageNumber: Page number, default first page if not given
    ///   - pageSize: Page size, default 50 per page if not given
    ///   - completion: Closure called after operation is finished. Used to return operation execution result (success or failed)
    func getEvents(lat: Double, lon: Double, placeId: String, locationRadius: Double, pageNumber: Int, pageSize: Int, completion: @escaping VoidResultCompletion)
}
