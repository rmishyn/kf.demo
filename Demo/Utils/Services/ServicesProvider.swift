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
    
    let contentProvidersFactory: ContentProvidersFactoryProtocol
    
    // MARK: Lifecycle
    
    /// Initializer
    init(eventsService: EventsServiceProtocol,
         dbManager: DBManagement,
         contentProvidersFactory: ContentProvidersFactoryProtocol) {
        self.eventsService = eventsService
        self.dbManager = dbManager
        self.contentProvidersFactory = contentProvidersFactory
    }
    
}
