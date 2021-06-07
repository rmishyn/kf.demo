//
//  SceneCoordinator.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import UIKit

class SceneCoordinator: Coordinator {
    
    // MARK: Properties
    
    private let servicesProvider: ServicesProviding
    
    // MARK: Properties (Coordinator)
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    // MARK: Lifecycle
    
    init(navigationController: UINavigationController, servicesProvider: ServicesProviding) {
        self.navigationController = navigationController
        self.servicesProvider = servicesProvider
    }
    
    // MARK: Coordinator
    
    func start() {
        startEventsCoordinator()
    }
    
    // MARK: Private methods
    
    private func startEventsCoordinator() {
        let configuration = CoordinatorConfiguration<EventsCoordinatorOutput>(navigationController: self.navigationController,
                                                                            output: self,
                                                                            servicesProvider: self.servicesProvider)
        let coordinator = EventsCoordinator(configuration: configuration)
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
}

// MARK: - EventsCoordinatorOutput

extension SceneCoordinator: EventsCoordinatorOutput { }
