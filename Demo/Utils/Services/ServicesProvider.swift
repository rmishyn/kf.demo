//
//  ServicesProvider.swift
//  Demo
//
//  Created by Ruslan Mishyn on 06.06.2021.
//

import Foundation

class ServicesProvider: ServicesProviding {
    
    let eventsService: EventsServiceProtocol
    let dbManager: DBManagement
    
    // MARK: Lifecycle
    
    /// Initializer
    init(eventsService: EventsServiceProtocol,
         dbManager: DBManagement) {
        self.eventsService = eventsService
        self.dbManager = dbManager
    }
    
}
