//
//  EventsCoordinator.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import UIKit

protocol EventsCoordinatorOutput: AnyObject {}

class EventsCoordinator: Coordinator {
    
    // MARK: Properties
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private weak var output: EventsCoordinatorOutput!
    private let servicesProvider: ServicesProviding
    
    // MARK: Initialization
    
    init(configuration: CoordinatorConfiguration<EventsCoordinatorOutput>) {
        navigationController = configuration.navigationController
        navigationController.isNavigationBarHidden = true
        self.output = configuration.output
        self.servicesProvider = configuration.servicesProvider
    }
    
    // MARK: Coordinator
    
    func start() {
        setEvents()
    }
    
    // MARK: Private methods
    
    private func setEvents() {
        let configuration = EventsConfiguration()
        let viewController = EventsConfigurator().configure(output: self, configuration: configuration)
        navigationController.setViewControllers([viewController], animated: true)
    }
}

// MARK: - EventsOutput

extension EventsCoordinator: EventsOutput { }
