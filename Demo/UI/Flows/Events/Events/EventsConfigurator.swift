//
//  EventsConfigurator.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import Foundation

struct EventsConfiguration {
    let eventsService: EventsServiceProtocol
}

class EventsConfigurator {
    func configure(output: EventsOutput, configuration: EventsConfiguration) -> EventsViewController {
        let viewController = EventsViewController.controllerFromStoryboard(.main)
        let presenter = EventsPresenter(view: viewController, output: output, configuration: configuration)
        viewController.presenter = presenter
        return viewController
    }
}
