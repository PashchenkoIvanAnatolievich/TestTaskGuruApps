//
//  OnboardingCoordinator.swift
//  TestTaskGuruApps
//
//  Created by Пащенко Иван on 30.10.2025.
//

import UIKit

class OnboardingCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var delegate: OnboardingCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let networkService = NetworkService()
        let viewModel = OnboardingViewModel(networkService: networkService)
        
        viewModel.onboardingDidFinish = { [weak self] in
            guard let self = self else { return }
            
            LogService.log("OnboardingCoordinator: Получил сигнал от ViewModel. Сообщаю AppCoordinator.")
            self.delegate?.didFinishOnboarding(coordinator: self)
        }
        
        let viewController = OnboardingViewController(viewModel: viewModel)
        navigationController.isNavigationBarHidden = true
        navigationController.setViewControllers([viewController], animated: true)
    }
    
}
