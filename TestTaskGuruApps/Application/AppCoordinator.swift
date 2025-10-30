//
//  AppCoordinator.swift
//  TestTaskGuruApps
//
//  Created by Пащенко Иван on 30.10.2025.
//

import UIKit

protocol OnboardingCoordinatorDelegate: AnyObject {
    func didFinishOnboarding(coordinator: OnboardingCoordinator)
}

class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    private let window: UIWindow
    
    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        showOnboarding()
    }
}

extension AppCoordinator {
    private func showOnboarding() {
        let onboardingCoordinator = OnboardingCoordinator(navigationController: navigationController)
        onboardingCoordinator.delegate = self
        childCoordinators.append(onboardingCoordinator)
        onboardingCoordinator.start()
    }
    
    private func showSalesScreen() {
        let salesCoordinator = SalesCoordinator(navigationController: navigationController)
        salesCoordinator.delegate = self
        childCoordinators.append(salesCoordinator)
        salesCoordinator.start()
    }
    
    private func showMainApp() {
        let mainVC = UIViewController()
        mainVC.view.backgroundColor = .systemGreen
        mainVC.title = "Main App Screen"
        navigationController.setViewControllers([mainVC], animated: true)
    }
    
    private func remove(coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}

extension AppCoordinator: OnboardingCoordinatorDelegate {
    func didFinishOnboarding(coordinator: OnboardingCoordinator) {
        remove(coordinator: coordinator)
        showSalesScreen()
    }
}

extension AppCoordinator: SalesCoordinatorDelegate {
    func didTappedClose() {
        showMainApp()
    }
    
    func didFinishSales(coordinator: SalesCoordinator) {
        LogService.log("AppCoordinator: Флоу продаж завершен. Показываю главный экран.")
        remove(coordinator: coordinator)
        showMainApp()
    }
    
    
}
