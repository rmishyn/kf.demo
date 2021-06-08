//
//  AppDelegateService.swift
//  Demo
//
//  Created by Ruslan Mishyn on 06.06.2021.
//

import Foundation

/// Service used to support global app functionality
class AppDelegateService {
    
    // MARK: Properties
    
    /// Object containing references to all global app services
    private(set) var servicesProvider: ServicesProviding!
    
    // MARK: Lifecycle
    
    /// Initializer
    init() {
        setup()
    }
    
    // MARK: Private
    
    /// Configure this service after initialization
    private func setup() {
        setupServices()
    }
    
    /// Create global services and preare an object containing references to all global app services
    private func setupServices() {
        
        let dbManager = DBManager()
        
        let contentProvidersFactory = ContentProvidersFactory()
        
        let sessionService = URLSessionService()
        let eventsService = EventsService(serverService: EventsServerService(core: sessionService), dbService: dbManager.eventsService)
        
        servicesProvider = ServicesProvider(eventsService: eventsService, dbManager: dbManager, contentProvidersFactory: contentProvidersFactory)
    }
}
