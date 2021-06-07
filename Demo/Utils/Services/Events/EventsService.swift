//
//  EventsService.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import Foundation

/// Service used to support events related functionality
class EventsService: EventsServiceProtocol {
    
    // MARK: Properties
    
    /// Service used to call API functionality
    private var serverService: EventsServerServiceProtocol
//    /// Service providing a functionality to operate with `Pie` objects in local database
//    private var dbService: DBObjectService<Event>
    
    // MARK: Initialization
    
    /// Initializer
    /// - Parameters:
    ///   - serverService: Service used to call API functionality
    ///   - dbService: Service providing a functionality to operate with `Pie` objects in local database
    ///   - instrumentsService: Service used to support securities instruments related functionality
    ///   - sessionIdProvider: Provider of API session identifier
    init(serverService: EventsServerServiceProtocol/*, dbService: DBObjectService<Event>*/) {
        self.serverService = serverService
//        self.dbService = dbService
    }
    
    // MARK: EventsServiceProtocol
    
    func getEvents(lat: Double, lon: Double, placeId: String, locationRadius: Double, pageNumber: Int, pageSize: Int, completion: @escaping VoidResultCompletion) {
        let _completion: VoidResultCompletion = { (result) in  DispatchQueue.main.async { completion(result) } }
        
        serverService.getEvents(lat: lat, lon: lon, placeId: placeId, locationRadius: locationRadius, pageNumber: pageNumber, pageSize: pageSize, completion: { [weak self] (result) in
            guard let _ = self else { return }
            switch result {
            case .failure(let error):
                _completion(.failure(error))
            case .success(let dict):
                dprint(category: .networking, "Events dictionary received:\n\(dict)")
                
                guard let responseData = dict[ServerAPI.ResponseKey.data.rawValue] as? [String : Any],
                      let eventsData = responseData[ServerAPI.ResponseKey.events.rawValue] as? [[String : Any]],
                      let venuesData = responseData[ServerAPI.ResponseKey.venues.rawValue] as? [[String : Any]] else {
                    let error = NSError(domain: .networking, errorCode: .invalidResponse)
                    _completion(.failure(error))
                    return
                }
                
                _completion(.success(()))
            }
        })
    }
}
