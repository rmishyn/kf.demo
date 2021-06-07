//
//  EventsPresenter.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import Foundation

class EventsPresenter: EventsPresentation {
    
    // MARK: Properties
    
    private weak var output: EventsOutput!
    private unowned var view: EventsInterface!
    
    private let eventsService: EventsServiceProtocol
    
    private var isEventsRequestActive: Bool = false
    
    // MARK: Public methods
    
    init(view: EventsInterface, output: EventsOutput, configuration: EventsConfiguration) {
        self.view = view
        self.output = output
        self.eventsService = configuration.eventsService
        refreshEvents()
    }
    
    // MARK: Private methods
    
    private func refreshEvents() {
        guard !isEventsRequestActive else { return }
        isEventsRequestActive = true
        let requestParameters = AppConfiguration.DefaultEventsRequestParameters.self
        eventsService.getEvents(lat: requestParameters.lat,
                                lon: requestParameters.lon,
                                placeId: requestParameters.placeId,
                                locationRadius: requestParameters.locationRadius,
                                pageNumber: requestParameters.pageNumber,
                                pageSize: requestParameters.pageSize, completion: { [weak self] (result) in
                                    guard let self = self else { return }
                                    defer { self.isEventsRequestActive = false }
                                    switch result {
                                    case .failure: break
                                    case .success: break
                                    }
                                })
    }
}
