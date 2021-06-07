//
//  EventsServerServiceContract.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import Foundation

protocol EventsServerServiceProtocol: ServerRequesting, ServerResponseProcessing {
    /// Fetch all events
    /// - Parameters:
    ///   - lat: A floating-point numbers representing longitude (decimal degrees)
    ///   - lon: A floating-point numbers representing latitude (decimal degrees)
    ///   - placeId: A string from google to uniquely identify a city. It is strongly recommended to also provide long & lat at the same time when using this param
    ///   - locationRadius: The range of a circle with locationCoordinates as center and locationRadius as radius in kilometers and 200 KM will be used if not given
    ///   - pageNumber: Page number, default first page if not given
    ///   - pageSize: Page size, default 50 per page if not given
    ///   - completion: Closure called after request is performed. Used to return list of pies data or error description (if request or parsing failed)
    func getEvents(lat: Double, lon: Double, placeId: String, locationRadius: Double, pageNumber: Int, pageSize: Int, completion: @escaping DictResultCompletion)
}

extension EventsServerServiceProtocol {
    
    func getEvents(lat: Double, lon: Double, placeId: String, locationRadius: Double, pageNumber: Int, pageSize: Int, completion: @escaping DictResultCompletion) {
        performRequest(EventsAPIRouter.getEvents(lat: lat, lon: lon, placeId: placeId, locationRadius: locationRadius, pageNumber: pageNumber, pageSize: pageSize),
                       logLabel: "Get Events",
                       completion: completion)
    }
}
