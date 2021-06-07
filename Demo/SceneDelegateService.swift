//
//  SceneDelegateService.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import UIKit

/// Service used to configure scene and provide additional global functionality to scene
class SceneDelegateService {
    
    // MARK: Properties
    
    /// The main window associated with the scene
    private(set) var window: UIWindow!
    /// Root coordinator used to start screens flow and handle it during lifecycle
    private(set) var sceneCoordinator: SceneCoordinator!
    /// Object containing references to all global app services
    private var servicesProvider: ServicesProviding

    
    // MARK: Lifecycle
    
    /// Initializer
    /// - Parameters:
    ///   - window: The main window associated with the scene
    ///   - servicesProvider: Object containing references to all global app services
    ///   - unauthorizedAPIResponseProcessor: Objects having ability to process an API response that request doesn't contain valid authentication token
    init(window: UIWindow, servicesProvider: ServicesProviding) {
        self.window = window
        self.servicesProvider = servicesProvider
        setup()
    }
    
    // MARK: Private methods
    
    /// Configure this service on initialization. Setup and start root screens coordinator
    private func setup() {
        setupSceneCoordinator()
        configureAppearance()
    }
    
    /// Setup and start root screens coordinator
    private func setupSceneCoordinator() {
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        window.rootViewController = navigationController
        sceneCoordinator = SceneCoordinator(navigationController: navigationController, servicesProvider: servicesProvider)
        sceneCoordinator.start()
        window.makeKeyAndVisible()
    }
    
    /// Configure global apperance of UI classes
    private func configureAppearance() {
    }
}
