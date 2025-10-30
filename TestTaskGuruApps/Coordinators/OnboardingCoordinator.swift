//
//  OnboardingCoordinator.swift
//  TestTaskGuruApps
//
//  Created by Пащенко Иван on 30.10.2025.
//

import UIKit

class OnboardCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = OnboardingViewModel()
        
        viewModel.didFinishOnboarding = { [weak self] in
            self?.showSalesScreen()
        }
        
        let viewController = OnboardViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension OnboardCoordinator {
    private func showSalesScreen() {
        // Здесь будет запущен следующий флоу - экран продаж
        print("Координатор: Онбординг завершен, показываю экран продаж.")
    }
}
