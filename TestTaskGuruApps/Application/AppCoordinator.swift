//
//  AppCoordinator.swift
//  TestTaskGuruApps
//
//  Created by Пащенко Иван on 30.10.2025.
//

import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]?
    
    private let window: UIWindow
    
    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let onboardingCoordinator = OnboardCoordinator(navigationController: navigationController)
        
        self.childCoordinators?.append(onboardingCoordinator)
        
        onboardingCoordinator.start()
    }
}
