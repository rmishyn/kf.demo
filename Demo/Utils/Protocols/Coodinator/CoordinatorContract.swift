//
//  Coordinator.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import UIKit

struct CoordinatorConfiguration<T> {
    let navigationController: UINavigationController
    let output: T
    let servicesProvider: ServicesProviding
    
    init(navigationController: UINavigationController, output: T, servicesProvider: ServicesProviding) {
        self.navigationController = navigationController
        self.output = output
        self.servicesProvider = servicesProvider
    }
}

/// Protocol describing a scenes coordinator. Coordinators are used to support "MVP with coordinators" architecture pattern
protocol Coordinator: AnyObject {
    
    /// Collection of coordinators used to support subflows inside single parent flow
    var childCoordinators: [Coordinator] { get set }
    
    /// Navigation controller used as start point of flow hadled by this coordinator
    var navigationController: UINavigationController { get }
    
    /// Run coordinator flow
    func start()
    
    /// Add child coordinator to `childCoordinators` collection
    /// - Parameter coordinator: Child coordinator which should be added
    func addChildCoordinator(_ coordinator: Coordinator)
    
    /// Pop top visible view controller in `navigationController`'s `viewControllers` stack
    /// - Parameter animated: Pass true to animate the transition
    func popViewController(animated: Bool)
    /// Dismiss presented view controller
    /// - Parameter animated: Pass true to animate the transition
    func dismissView(animated: Bool)
}

/// Protocol describing an ability of coordinatpr to process finishing events from child coordinator. This may happen when subflow is completed
protocol ChildCoordinatorFinishing {
    /// Process a child coordinator finishing event right before child subflow will finish
    func willFinish(coordinator: Coordinator)
    /// Process a child coordinator finishing event right after child subflow did finish
    func didFinish(coordinator: Coordinator)
}

extension Coordinator {
    
    func addChildCoordinator(_ coordinator: Coordinator) {
        for element in childCoordinators {
            if element === coordinator {
                return
            }
        }
        childCoordinators.append(coordinator)
    }
    
    func popViewController(animated: Bool = true) {
        navigationController.popViewController(animated: animated)
    }
    
    func dismissView(animated: Bool = true) {
        navigationController.visibleViewController?.dismiss(animated: animated, completion: nil)
    }
}

extension ChildCoordinatorFinishing where Self: Coordinator {
    func willFinish(coordinator: Coordinator) {
        
    }
    
    func didFinish(coordinator: Coordinator) {
        childCoordinators.removeAll(where: { $0 === coordinator })
    }
}
