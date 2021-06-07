//
//  EventsServerService.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import Foundation

/// Class used to call API functionality related to Portfolio/Watchlist
class EventsServerService: EventsServerServiceProtocol {
    
    // MARK: Properties
    
    let core: ServerService
    
    // MARK: Initialization
    
    /// Initializer
    /// - Parameter core: Service which provides interaction with remote server
    init(core: ServerService) {
        self.core = core
    }
}
