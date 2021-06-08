//
//  EventsConfigurator.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import Foundation

struct EventsConfiguration {
    let eventsService: EventsServiceProtocol
    let dbEventsService: DBObjectService<Event>
    let contentProvidersFactory: ContentProvidersFactoryProtocol
}

class EventsConfigurator {
    func configure(output: EventsOutput, configuration: EventsConfiguration) -> EventsViewController {
        let viewController = EventsViewController.controllerFromStoryboard(.main)
        let presenter = EventsPresenter(view: viewController, output: output, configuration: configuration)
        viewController.presenter = presenter
        return viewController
    }
}
