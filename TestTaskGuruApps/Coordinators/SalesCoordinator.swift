//
//  SalesCoordinator.swift
//  TestTaskGuruApps
//
//  Created by Пащенко Иван on 30.10.2025.
//

import UIKit

protocol SalesCoordinatorDelegate: AnyObject {
    func didFinishSales(coordinator: SalesCoordinator)
    func didTappedClose()
}

class SalesCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var delegate: SalesCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let salesViewController = SalesViewController()
        
        salesViewController.onPurchaseSuccess = { [weak self] in
            guard let self = self else { return }
            self.delegate?.didFinishSales(coordinator: self)
        }
        
        salesViewController.onClose = { [weak self] in
            guard let self = self else { return }
            self.delegate?.didTappedClose()
        }
        
        LogService.log("SalesCoordinator: Показываю SalesViewController.")
        navigationController.setViewControllers([salesViewController], animated: true)
    }
}
