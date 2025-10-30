//
//  SalesCoordinator.swift
//  TestTaskGuruApps
//
//  Created by Пащенко Иван on 30.10.2025.
//

import UIKit

class SalesCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let salesViewController = SalesViewController()
        LogService.log("SalesCoordinator: Показываю SalesViewController.")
        navigationController.setViewControllers([salesViewController], animated: true)
    }
}
