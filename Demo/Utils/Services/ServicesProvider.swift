//
//  ServicesProvider.swift
//  Demo
//
//  Created by Ruslan Mishyn on 06.06.2021.
//

import Foundation

class ServicesProvider: ServicesProviding {
    
    let eventsService: EventsServiceProtocol
    
    // MARK: Lifecycle
    
    /// Initializer
    init(eventsService: EventsServiceProtocol) {
        self.eventsService = eventsService
    }
    
}
